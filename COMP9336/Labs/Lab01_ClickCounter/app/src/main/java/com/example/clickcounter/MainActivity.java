package com.example.clickcounter;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;
import android.view.View;

public class MainActivity extends Activity {
    int clickTime = 0;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button btn = (Button) findViewById(R.id.button);
        btn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                myClick(v);
            }
        });
    }

//    @Override
//    public boolean onCreateOptionsMenu(Menu	menu)	{
//        getMenuInflater().inflate(R.menu.main,	menu);
//        return true;
//    }

    public void myClick(View v) {
        TextView txCounter = (TextView) findViewById(R.id.editText);
        TextView fuck = (TextView) findViewById(R.id.textView);
        fuck.setText("FUCK YOU!!!!!!!");
        txCounter.setText(Integer.toString(++clickTime));
        txCounter.setVisibility(View.VISIBLE);
        txCounter.setTextSize(30);
    }

}
