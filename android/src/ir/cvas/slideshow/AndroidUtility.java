package ir.cvas.slideshow;

import android.content.Context;
import android.os.PowerManager;

public class AndroidUtility extends org.qtproject.qt5.android.bindings.QtActivity
{
    public void onCreate(android.os.Bundle savedInstanceState){
            super.onCreate(savedInstanceState);
            this.getWindow().addFlags(android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }
}



