//package com.example.hellowifi;
//
//import android.app.AlertDialog;
//import android.app.Dialog;
//import android.content.DialogInterface;
//import android.content.Intent;
//import android.support.v7.app.AppCompatActivity;
//import android.os.Bundle;
//import android.view.View;
//import android.widget.EditText;
//import android.widget.TextView;
//import android.widget.Button;
//import android.widget.Toast;
//
//
//public class Main2Activity extends AppCompatActivity {
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_main2);
//
//        Intent intent = getIntent();
//        String val = ((Intent) intent).getStringExtra("name");
//
//        val = "Are you connecting to " + val + "?\n";
//
//        TextView tv = (TextView) findViewById(R.id.textView);
//        tv.setText(val);
//
//        Button cancelBtn = (Button) findViewById(R.id.cancelBtn);
//        Button connectBtn = (Button) findViewById(R.id.connectBtn);
//
//        // exit dialog
//        cancelBtn.setOnClickListener(new View.OnClickListener() {
//            public void onClick(View v) {
//                finish();
//            }
//        });
//        // try to connect wifi with input username and password
//        connectBtn.setOnClickListener(new View.OnClickListener() {
//            public void onClick(View v) {
//                EditText editU = (EditText) findViewById(R.id.username);
//                EditText editP = (EditText) findViewById(R.id.password);
//                String username = editU.getText().toString();
//                String password = editP.getText().toString();
//
//                Toast.makeText(Main2Activity.this, "usr" + username+"pwd"+password, Toast.LENGTH_SHORT).show();
//                finish();
//            }
//        });
//
//    }
//}
