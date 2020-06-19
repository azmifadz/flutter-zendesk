package com.codeheadlabs.zendesk;

import android.content.Intent;

import com.zendesk.service.ErrorResponse;
import com.zendesk.service.ZendeskCallback;
import com.zopim.android.sdk.api.ZopimChat;
import com.zopim.android.sdk.model.VisitorInfo;
import com.zopim.android.sdk.prechat.ZopimChatActivity;

import java.util.ArrayList;
import java.util.List;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import zendesk.core.AnonymousIdentity;
import zendesk.core.Identity;
import zendesk.core.Zendesk;
import zendesk.support.Category;
import zendesk.support.HelpCenterProvider;
import zendesk.support.Request;
import zendesk.support.Support;
import zendesk.support.guide.HelpCenterActivity;

/** ZendeskPlugin */
public class ZendeskPlugin implements MethodCallHandler {
  private final Registrar mRegistrar;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.codeheadlabs.zendesk");
    channel.setMethodCallHandler(new ZendeskPlugin(registrar));
  }

  private ZendeskPlugin(Registrar registrar) {
    this.mRegistrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "init":
        handleInit(call, result);
        break;
      case "initSupportSDK":
        handleInitSupportSDK(call, result);
        break;
      case "setVisitorInfo":
        handleSetVisitorInfo(call, result);
        break;
      case "startChat":
        handleStartChat(call, result);
        break;
      case "startSupportSDK":
        handleStartSupportSDK(call, result);
        break;
      case "helpCallback":
        handleListCallBack(call, result);
        //result.success();
        break;
      case "list":
        handleList(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void handleInit(MethodCall call, Result result) {
    ZopimChat.init((String) call.argument("accountKey"));
    result.success(true);
  }

  private void handleInitSupportSDK(MethodCall call, Result result) {

    String appId = "";
    String clientId = "";
    String url = "";

    if (call.hasArgument("appId")) {
      appId = (String) call.argument("appId");
    }
    if (call.hasArgument("clientId")) {
      clientId = (String) call.argument("clientId");
    }
    if (call.hasArgument("url")) {
      url = (String) call.argument("url");
    }

    Log.d("appId", appId);
    Log.d("clientId", clientId);
    Log.d("url", url);

    Zendesk.INSTANCE.init(mRegistrar.activeContext(), url, appId, clientId);
    Identity identity = new AnonymousIdentity();
    Zendesk.INSTANCE.setIdentity(identity);

    Support.INSTANCE.init(Zendesk.INSTANCE);

    result.success(true);
  }

  private void handleSetVisitorInfo(MethodCall call, Result result) {
    VisitorInfo.Builder builder = new VisitorInfo.Builder();
    if (call.hasArgument("name")) {
      builder.name((String) call.argument("name"));
    }
    if (call.hasArgument("email")) {
      builder.name((String) call.argument("email"));
    }
    if (call.hasArgument("phoneNumber")) {
      builder.phoneNumber((String) call.argument("phoneNumber"));
    }
    if (call.hasArgument("note")) {
      builder.note((String) call.argument("note"));
    }
    ZopimChat.setVisitorInfo(builder.build());
    result.success(true);
  }

  private void handleStartChat(MethodCall call, Result result) {
    Intent intent = new Intent(mRegistrar.activeContext(), ZopimChatActivity.class);
    mRegistrar.activeContext().startActivity(intent);
    result.success(true);
  }

  private void handleList(MethodCall call, Result result) {

    final List<String> list = new ArrayList<>();
    list.add("Phone number 1");
    list.add("Phone number 2");
    list.add("Phone number 3");

    result.success(list);
  }

  private void handleStartSupportSDK(MethodCall call, Result result) {

    HelpCenterActivity.builder()
            .show(mRegistrar.activeContext());
    result.success(true);
  }

  private void handleListCallBack(MethodCall call, final Result result) {

    HelpCenterProvider provider = Support.INSTANCE.provider().helpCenterProvider();

    //result.success('s');
    provider.getCategories(new ZendeskCallback<List<Category>>() {
      @Override
      public void onSuccess(List<Category> categories) {
        // Handle the success

        final List<String> list = new ArrayList<>();

        for (int i=0; i < categories.size(); i++) {

          Category cat = categories.get(i);

          Log.d("handleListCallBack", cat.getName());
          list.add(cat.getName());
        }

        result.success(list);
      }

      @Override
      public void onError(ErrorResponse errorResponse) {
        // Handle the error
      }
    });
  }
}
