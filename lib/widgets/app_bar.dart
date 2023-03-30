import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AppBarUI{
  const AppBarUI({Key? key, required this.title, this.isEnableDrawer, this.isEnableBack, this.onAdd, this.onSync});
  final String title;
  final VoidCallback? onAdd;
  final VoidCallback? onSync;
  final bool? isEnableBack;
  final bool? isEnableDrawer;

  void _openDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  AppBar build(BuildContext context) {
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    if(deviceType == DeviceScreenType.desktop || deviceType == DeviceScreenType.tablet){
      return AppBar(
        leadingWidth: isEnableBack == true ? null : 0,
        title: Text(title),
        leading: isEnableBack == true ? IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back)) : const SizedBox(width: 0, height: 0),
        actions: [
          if(onAdd != null) IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
          if(onSync != null) IconButton(onPressed: onSync, icon: const Icon(Icons.sync)),
        ],
      );
    }else{
      return AppBar(
        title: Text(title),
        centerTitle: true,
        leading: isEnableDrawer == true ? Builder(builder: (context) => IconButton(onPressed: ()=>_openDrawer(context), icon: const Icon(Icons.menu)))  : (isEnableBack == true ? IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back)) : null),
        actions: [
          if(onAdd != null) IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
          if(onSync != null) IconButton(onPressed: onSync, icon: const Icon(Icons.sync)),
        ],
      );
    }
  }
}
