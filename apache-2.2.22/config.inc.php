<?php

$cfg['blowfish_secret'] = '9ddwAC*%^g$559rU';

$i = 0;

$i++;

$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = '127.0.0.1';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = TRUE;
$cfg['Servers'][$i]['AllowNoPassword'] = FALSE;

$cfg['LoginCookieValidity'] = 86400;
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
$cfg['Lang'] = 'en';
$cfg['MaxRows'] = 1000;
$cfg['DisplayBinaryAsHex'] = FALSE;
$cfg['ProtectBinary'] = FALSE;
$cfg['MaxDbList'] = 1000;
$cfg['MaxTableList'] = 1000;
$cfg['ExecTimeLimit'] = 300;
$cfg['NavigationTreeEnableGrouping'] = FALSE;
$cfg['MaxNavigationItems'] = 1000;
$cfg['NavigationTreeDisplayItemFilterMinimum'] = 1;
$cfg['NavigationTreeDisplayDbFilterMinimum'] = 1;

$_REQUEST['display_blob'] = TRUE;
