package com.example.flutter_app

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.util.Base64
import android.util.Log
import androidx.multidex.MultiDex
//import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.googlesignin.GoogleSignInPlugin
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.*


class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        printHashKey(this@Application)
        //FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(newBase)
        MultiDex.install(this)
    }

    override fun registerWith(registry: PluginRegistry) {
        //GoogleSignInPlugin.registerWith(registry.registrarFor("io.flutter.plugins.googlesignin"))
        //  FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
    }

    var channel: MethodChannel? = null
    var counter: Timer? = null

    fun printHashKey(pContext: Context) {
        try {
            val info: PackageInfo = pContext.getPackageManager()
                    .getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val hashKey = String(Base64.encode(md.digest(), 0))
                Log.i("HASHHHH", "printHashKey() Hash Key: $hashKey")
            }
        } catch (e: NoSuchAlgorithmException) {
            Log.e("HASHHHH", "printHashKey()", e)
        } catch (e: Exception) {
            Log.e("HASHHHH", "printHashKey()", e)
        }
    }

}