package com.ali.nourmed.sleep_timer

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import kotlin.time.Duration


/**
 * Implementation of App Widget functionality.
 */
class HomeTimerWidget : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId,widgetData)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

}

@RequiresApi(Build.VERSION_CODES.O)
internal  fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int,
    widgetData: SharedPreferences
) {
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.home_timer_widget).apply {
        val rootPendingIntent = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            Uri.parse("myAppWidget://message?message=widgetClicked")
        )
        // on clicking widget
        setOnClickPendingIntent(R.id.widget_root,rootPendingIntent,)
        val currentDurationAsString: String? = widgetData.getString("duration","00:00:30")
        val timerDurationAsString: String? = widgetData.getString("timer_duration","00:00:30")
        val timerStatus:String? = widgetData.getString("timer_status","stopped")
        val progress:Int? = widgetData.getInt("progress",0)
        setProgressBar(R.id.circularProgressbar, 100,progress ?: 0,false)

        if (timerStatus != null){
            when (timerStatus) {
                "stopped" -> {
                    setViewVisibility(R.id.pause_timer, View.INVISIBLE)
                    setViewVisibility(R.id.start_timer, View.VISIBLE)
                    setTextViewText(R.id.timer_text, timerDurationAsString)
                }
                "running" -> {
                    setViewVisibility(R.id.pause_timer, View.VISIBLE)
                    setViewVisibility(R.id.start_timer, View.INVISIBLE)
                    setTextViewText(R.id.timer_text, currentDurationAsString)
                }
                "paused" -> {
                    setViewVisibility(R.id.pause_timer, View.INVISIBLE)
                    setViewVisibility(R.id.start_timer, View.VISIBLE)
                    setTextViewText(R.id.timer_text, currentDurationAsString)

                }
                "cancelled" -> {
                    setViewVisibility(R.id.pause_timer, View.INVISIBLE)
                    setViewVisibility(R.id.start_timer, View.VISIBLE)
                    setTextViewText(R.id.timer_text, timerDurationAsString)
                }
            }
        }

        // Open App on Widget Click
        val startTimerPendingIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("myAppWidget://start_timer")
            )
        val pauseTimerPendingIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("myAppWidget://pause_timer")
        )
        val resetTimerPendingIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("myAppWidget://reset_timer")
        )

        setOnClickPendingIntent(R.id.start_timer,startTimerPendingIntent)
        setOnClickPendingIntent(R.id.pause_timer,pauseTimerPendingIntent)
        setOnClickPendingIntent(R.id.reset_timer,resetTimerPendingIntent)
    }

    //    Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}