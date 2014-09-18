<?php

$cfg['blowfish_secret'] = '9ddwAC*%^g$559rU';

$i = 0;

$i++;

$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = '127.0.0.1';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = false;

$cfg['LoginCookieValidity'] = 86400;
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
$cfg['Lang'] = 'en';
$cfg['MaxRows'] = 1000;
$cfg['DisplayBinaryAsHex'] = false;
$cfg['ProtectBinary'] = false;
$cfg['MaxDbList'] = 1000;
$cfg['MaxTableList'] = 1000;
$cfg['ExecTimeLimit'] = 300;
$cfg['NavigationTreeEnableGrouping'] = false;
$cfg['MaxNavigationItems'] = 1000;
$cfg['MainBackground'] = "#0f0";

$_REQUEST['display_blob'] = true;
