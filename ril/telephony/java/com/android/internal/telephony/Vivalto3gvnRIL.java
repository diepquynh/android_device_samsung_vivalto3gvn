/*
 * Copyright (C) 2012 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.android.internal.telephony;

import static com.android.internal.telephony.RILConstants.*;

import android.content.Context;
import android.os.AsyncResult;
import android.os.Message;
import android.os.Parcel;
import android.os.SystemProperties;
import android.telephony.Rlog;
import android.telephony.PhoneNumberUtils;
import android.telephony.ModemActivityInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;

import com.android.internal.telephony.uicc.SpnOverride;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.RILConstants;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

/**
 * Custom RIL to handle unique behavior of SPRD RIL
 *
 * {@hide}
 */
public class Vivalto3gvnRIL extends SamsungSPRDRIL implements CommandsInterface {

    public static class TelephonyPropertyProvider implements TelephonyManager.TelephonyPropertyProvider {

        public TelephonyPropertyProvider() { }

        @Override
        public void setTelephonyProperty(int phoneId, String property, String value) {
            if (SubscriptionManager.isValidPhoneId(phoneId)) {
                String actualProp = getActualProp(phoneId, property);
                String propVal = value == null ? "" : value;
                if (actualProp.length() > SystemProperties.PROP_NAME_MAX
                        || propVal.length() > SystemProperties.PROP_VALUE_MAX) {
                    Rlog.d(RILJ_LOG_TAG, "setTelephonyProperty: property to long" +
                            " phoneId=" + phoneId +
                            " property=" + property +
                            " value=" + value +
                            " actualProp=" + actualProp +
                            " propVal" + propVal);
                } else {
                    Rlog.d(RILJ_LOG_TAG, "setTelephonyProperty: success" +
                            " phoneId=" + phoneId +
                            " property=" + property +
                            " value=" + value +
                            " actualProp=" + actualProp +
                            " propVal=" + propVal);
                    SystemProperties.set(actualProp, propVal);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "setTelephonyProperty: invalid phoneId=" + phoneId +
                        " property=" + property +
                        " value=" + value);
            }
        }

        @Override
        public String getTelephonyProperty(int phoneId, String property, String defaultVal) {
            String result = defaultVal;
            if (SubscriptionManager.isValidPhoneId(phoneId)) {
                String actualProp = getActualProp(phoneId, property);
                String propVal = SystemProperties.get(actualProp);
                if (!propVal.isEmpty()) {
                    result = propVal;
                    Rlog.d(RILJ_LOG_TAG, "getTelephonyProperty: return result=" + result +
                            " phoneId=" + phoneId +
                            " property=" + property +
                            " defaultVal=" + defaultVal +
                            " actualProp=" + actualProp +
                            " propVal=" + propVal);
                }
            } else {
                Rlog.e(RILJ_LOG_TAG, "getTelephonyProperty: invalid phoneId=" + phoneId +
                        " property=" + property +
                        " defaultVal=" + defaultVal);
            }
            return result;
        }

        private String getActualProp(int phoneId, String prop) {
            return phoneId <= 0 ? prop : prop + (phoneId + 1);
        }
    }

    public Vivalto3gvnRIL(Context context, int preferredNetworkType, int cdmaSubscription) {
        this(context, preferredNetworkType, cdmaSubscription, null);
    }

    public Vivalto3gvnRIL(Context context, int preferredNetworkType,
            int cdmaSubscription, Integer instanceId) {
        super(context, preferredNetworkType, cdmaSubscription, instanceId);
    }

    @Override
    public void startLceService(int reportIntervalMs, boolean pullMode, Message response) {
        riljLog("Link Capacity Estimate (LCE) service is not supported!");
        if (response != null) {
            AsyncResult.forMessage(response, null, new CommandException(
                    CommandException.Error.REQUEST_NOT_SUPPORTED));
            response.sendToTarget();
        }
    }

    @Override
    protected Object
    responseCallList(Parcel p) {
        int num;
        int voiceSettings;
        ArrayList<DriverCall> response;
        DriverCall dc;

        num = p.readInt();
        response = new ArrayList<DriverCall>(num);

        if (RILJ_LOGV) {
            riljLog("responseCallList: num=" + num +
                    " mEmergencyCallbackModeRegistrant=" + mEmergencyCallbackModeRegistrant +
                    " mTestingEmergencyCall=" + mTestingEmergencyCall.get());
        }
        for (int i = 0 ; i < num ; i++) {
            dc = new DriverCall();

            dc.state = DriverCall.stateFromCLCC(p.readInt());
            // & 0xff to truncate to 1 byte added for us, not in RIL.java
            dc.index = p.readInt() & 0xff;
            dc.TOA = p.readInt();
            dc.isMpty = (0 != p.readInt());
            dc.isMT = (0 != p.readInt());
            dc.als = p.readInt();
            voiceSettings = p.readInt();
            dc.isVoice = (0 != voiceSettings);
            boolean isVideo = (0 != p.readInt());
            int call_type = p.readInt();            // Samsung CallDetails
            int call_domain = p.readInt();          // Samsung CallDetails
            String csv = p.readString();            // Samsung CallDetails
            dc.isVoicePrivacy = (0 != p.readInt());
            dc.number = p.readString();
            int np = p.readInt();
            dc.numberPresentation = DriverCall.presentationFromCLIP(np);
            dc.name = p.readString();
            dc.namePresentation = p.readInt();
            int uusInfoPresent = p.readInt();
            if (uusInfoPresent == 1) {
                dc.uusInfo = new UUSInfo();
                dc.uusInfo.setType(p.readInt());
                dc.uusInfo.setDcs(p.readInt());
                byte[] userData = p.createByteArray();
                dc.uusInfo.setUserData(userData);
                riljLogv(String.format("Incoming UUS : type=%d, dcs=%d, length=%d",
                                dc.uusInfo.getType(), dc.uusInfo.getDcs(),
                                dc.uusInfo.getUserData().length));
                riljLogv("Incoming UUS : data (string)="
                        + new String(dc.uusInfo.getUserData()));
                riljLogv("Incoming UUS : data (hex): "
                        + IccUtils.bytesToHexString(dc.uusInfo.getUserData()));
            } else {
                riljLogv("Incoming UUS : NOT present!");
            }

            // Make sure there's a leading + on addresses with a TOA of 145
            dc.number = PhoneNumberUtils.stringFromStringAndTOA(dc.number, dc.TOA);

            response.add(dc);

            if (dc.isVoicePrivacy) {
                mVoicePrivacyOnRegistrants.notifyRegistrants();
                riljLog("InCall VoicePrivacy is enabled");
            } else {
                mVoicePrivacyOffRegistrants.notifyRegistrants();
                riljLog("InCall VoicePrivacy is disabled");
            }
        }

        Collections.sort(response);

        if ((num == 0) && mTestingEmergencyCall.getAndSet(false)) {
            if (mEmergencyCallbackModeRegistrant != null) {
                riljLog("responseCallList: call ended, testing emergency call," +
                            " notify ECM Registrants");
                mEmergencyCallbackModeRegistrant.notifyRegistrant();
            }
        }

        return response;
    }
}
