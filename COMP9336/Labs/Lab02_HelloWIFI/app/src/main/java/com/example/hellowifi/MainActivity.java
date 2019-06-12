package com.example.hellowifi;

import android.Manifest;
import android.app.AlertDialog;
import android.net.ConnectivityManager;
import android.os.CountDownTimer;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.net.wifi.*;
import android.support.annotation.RequiresApi;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.os.Build;
import android.util.Log;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class MainActivity extends AppCompatActivity {

    public WifiManager mwifiManager;
    private ListView mwifiList;
    private List<ScanResult> results;
    private ArrayList<String> arrayList = new ArrayList<>();
    private ArrayAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        String[] PERMS_INITIAL = {
                Manifest.permission.ACCESS_FINE_LOCATION,
        };
        ActivityCompat.requestPermissions(this, PERMS_INITIAL, 127);

        Button scanWifiBtn = (Button) findViewById(R.id.button);

        scanWifiBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                scanWifi();
            }
        });

        mwifiList = findViewById(R.id.wifiList);
        mwifiManager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);

        if (!mwifiManager.isWifiEnabled()) {
            mwifiManager.setWifiEnabled(true);
        }
        adapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, arrayList);
        mwifiList.setAdapter(adapter);
        mwifiList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String str = (String) ((TextView) view).getText();
                String[] lines = str.split("\\r?\\n");
                String wifiName = lines[0];
                wifiName = wifiName.substring(7);
                AlertDialog.Builder mBuilder = new AlertDialog.Builder(MainActivity.this);
                View mView = getLayoutInflater().inflate(R.layout.dialog_login, null);
                final TextView mWifiname = (TextView) mView.findViewById(R.id.textView);
                mWifiname.setText("Connect to " + wifiName);
                final String mWifi = wifiName;
                final String fullInfo = str;
                final EditText mUsername = (EditText) mView.findViewById(R.id.username);
                final EditText mPassword = (EditText) mView.findViewById(R.id.password);
                Button mConnect = (Button) mView.findViewById(R.id.btnLogin);

                mBuilder.setView(mView);
                final AlertDialog dialog = mBuilder.create();
                // set visibility for wifi portals whose capabilities contain "eap", which means need usr and pwd
                if (str.toLowerCase().contains("eap")) {
                    mUsername.setVisibility(View.VISIBLE);
                } else {
                    mUsername.setVisibility(View.INVISIBLE);
                }
                dialog.show();

                mConnect.setOnClickListener(new View.OnClickListener() {
                    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
                    @Override
                    public void onClick(View v) {
                        String username = mUsername.getText().toString();
                        String password = mPassword.getText().toString();

                        ConnectWifi(mWifi, username, password, fullInfo);

                        new CountDownTimer(10000, 1000) {
                            @Override
                            public void onTick(long l) {

                            }
                            @Override
                            public void onFinish() {
                                ConnectivityManager cm = (ConnectivityManager) getApplicationContext().getSystemService(CONNECTIVITY_SERVICE);
                                if (cm.getActiveNetworkInfo() != null && cm.getActiveNetworkInfo().isConnected()) {
                                    int ip = mwifiManager.getConnectionInfo().getIpAddress();
                                    String ipAdd = Integer.toString(ip);
                                    Toast.makeText(getApplicationContext(), "Connect successfully to network: " + mWifi + "\nIP address: " + ipAdd, Toast.LENGTH_SHORT).show();
                                    dialog.dismiss();
                                } else {
                                    Toast.makeText(getApplicationContext(), "Wrong Input.", Toast.LENGTH_SHORT).show();
                                    dialog.show();
                                }
                            }
                        }.start();
                    }
                });
            }
        });
    }

    private void scanWifi() {
        if (!mwifiManager.isWifiEnabled()) {
            mwifiManager.setWifiEnabled(true);
        }
        arrayList.clear();
        registerReceiver(wifiReceiver, new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION));
        mwifiManager.startScan();
        Toast.makeText(this, "Scanning...", Toast.LENGTH_SHORT).show();
    }

    BroadcastReceiver wifiReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            results = mwifiManager.getScanResults();
            unregisterReceiver(this);

            HashMap<String, ScanResult> portal = new HashMap<>();
            for (ScanResult scanResult : results) {
                String wifiESSID = scanResult.SSID;             // name
                if (portal.get(wifiESSID) == null) {
                    portal.put(wifiESSID, scanResult);
                } else {
                    ScanResult existed_wifi = (ScanResult) portal.get(wifiESSID);
                    if (scanResult.level > existed_wifi.level) {
                        portal.remove(wifiESSID);
                        portal.put(wifiESSID, scanResult);
                    }
                }
            }
            List<ScanResult> sorted_portal = new ArrayList();
            for (Map.Entry<String, ScanResult> en: portal.entrySet()) {
                sorted_portal.add(en.getValue());
            }
            Collections.sort(sorted_portal, new Comparator<ScanResult>() {
                @Override
                public int compare(ScanResult o1, ScanResult o2) {
                    return o2.level - o1.level;
                }
            });
            sorted_portal = sorted_portal.subList(0, 4);
            Log.d("List", "s" + sorted_portal);

            for (ScanResult wifi: sorted_portal) {
                arrayList.add("ESSID: " + wifi.SSID + "\n"
                            + "BSSID: " + wifi.BSSID + "\n"
                            + "Signal Strength: " + wifi.level + "\n"
                            + "Encryption Mode: " + wifi.capabilities + "\n");
                adapter.notifyDataSetChanged();
            }
        }
    };

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
    public void ConnectWifi(String mwifi, String username, String password, String fullInfo) {
        WifiConfiguration wc = new WifiConfiguration();
        wc.allowedAuthAlgorithms.clear();
        wc.allowedGroupCiphers.clear();
        wc.allowedKeyManagement.clear();
        wc.allowedPairwiseCiphers.clear();
        wc.allowedProtocols.clear();

        if (fullInfo.toLowerCase().contains("eap")) {
            WifiEnterpriseConfig ec = new WifiEnterpriseConfig();
            wc.SSID = "\"" + mwifi + "\"";
            wc.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_EAP);
            wc.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.IEEE8021X);
            ec.setIdentity(username);
            ec.setPassword(password);
            ec.setEapMethod(WifiEnterpriseConfig.Eap.PEAP);
            Log.d("userinfo", "username" + username);
            Log.d("userinfo", "password" + password);
//            wc.hiddenSSID = true;
//            wc.status = WifiConfiguration.Status.ENABLED;
//            wc.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
//            wc.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);
//            wc.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK);
//            wc.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.TKIP);
//            wc.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.CCMP);
//            wc.allowedProtocols.set(WifiConfiguration.Protocol.RSN);
//            wc.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK);
            wc.enterpriseConfig = ec;
            Log.d("WifiPreference", "wifi " + mwifi);
//            mwifiManager.saveConfiguration();
            int netID1 = mwifiManager.addNetwork(wc);
            Log.d("WifiPreference", "add Network returned " + netID1);
            mwifiManager.disconnect();
//            boolean b = mwifiManager.enableNetwork(netID1, true);
//            Log.d("WifiPreference", "enableNetwork returned " + b );
            mwifiManager.enableNetwork(netID1, true);
            mwifiManager.reconnect();
            Toast.makeText(getApplicationContext(), "Connecting...", Toast.LENGTH_SHORT).show();
        } else {
            wc.SSID = "\"" + mwifi + "\"";
            wc.preSharedKey = "\"" + password + "\"";

            wc.status = WifiConfiguration.Status.ENABLED;
            wc.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
            wc.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);
            wc.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK);
            wc.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.TKIP);
            wc.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.CCMP);
            wc.allowedProtocols.set(WifiConfiguration.Protocol.RSN);
            mwifiManager.saveConfiguration();
            int netID2 = mwifiManager.addNetwork(wc);
            Log.d("WifiPreference", "add Network returned " + netID2);
            mwifiManager.disconnect();
            boolean b = mwifiManager.enableNetwork(netID2, true);
            Log.d("WifiPreference", "enableNetwork returned " + b );
            mwifiManager.enableNetwork(netID2, true);
            mwifiManager.reconnect();
            Toast.makeText(getApplicationContext(), "Connecting...", Toast.LENGTH_SHORT).show();
        }
    }


}

