#!/usr/bin/php
<?php
include("../setingan/global.inc.php");
include("../setingan/cms.fungsi.php");

$modemid = $argv[1];

//$ceklokal	= "select modemid,modem,configfile,msisdn,ussdpulsa from tbl_modem where modemid='$modemid'";
$ceklokal	= "select modemid,modem,configfile,msisdn,ussdpulsa from tbl_modem where 1";
$query		= sql($ceklokal);
$row	= sql_fetch_data($query);

$modemid = $row['modemid'];
$configfile = $row['configfile'];
$ussdpulsa = $row['ussdpulsa'];

if(!empty($modemid))
{
	system("killall -9 gammu-smsd");
	
	echo "\r Ready to Execute: gammu -c $configfile --identify \r";	
	$modem = shell_exec("gammu -c $configfile --identify");
	
	$sql	= "update tbl_modem set modem='$modem' where modemid='$modemid'";
	$hsl	= sql($sql);
	
	echo "\r Ready to Execute: gammu -c $configfile getussd $ussdpulsa \r";
	
	$hasil = shell_exec("gammu -c $configfile getussd $ussdpulsa");
	system("trap exit INT");
	
	$pulsa = explode("\n",$hasil);
	
	$jml = count($pulsa);
	
	for($i=0;$i<$jml;$i++)
	{
		$text = $pulsa[$i];
		if(preg_match("/Service reply/i",$text))
		{
			$infopulsa = explode(":",$text);
			$info = trim($infopulsa[1]);
			$info = str_replace('"',"",$info);
			$info = str_replace("'","",$info);
		}
	}
	
	
	$sql	= "update tbl_modem set pulsa='$info',cekpulsa='0' where modemid='$modemid'";
	$hsl	= sql($sql);

	system("gammu-smsd -c $configfile --daemon");
	
}
exit();

?>
