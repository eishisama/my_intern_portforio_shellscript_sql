#!/bin/sh
#####################################################
# TF 企画変更申請のチェックツール
#
# 内容：1時間以内に更新のあった放送枠より、企画変更ステータスが7であるものがあるかを確認し
# 該当レコードがあれば、そのレコードの前の履歴のステータスで5のものをみつけ、企画が同じかチェックする。
# 同じチェックの場合は、異常なので、メール通知するツール
# 
#
#####################################################
export NLS_LANG=Japanese_Japan.AL32UTF8
SUCCESS_FLG=0
ERROR_FLG=255

status=$SUCCESS_FLG
DISTFILE="/test/log/test_yoshimoto_sql_result_`date '+%Y%m%d'`.txt"

# Connect TF-DB .............. #
getTFData()
{
/usr/bin/sqlplus64 -s /nolog << EOF > ${DISTFILE}
whenever sqlerror exit 255
whenever oserror exit 200
conn TRIDB/viMncti4dxmPAJ43@tfdb91.hyk-sys.jp/orcl
set echo off
set feedback off
set pagesize 0
set linesize 30000

@/test/tf_kikaku_change_check.sql

exit
EOF
}

# メール送信 #######################
sendMailTF()
{
NGRECORED=`cat ${DISTFILE}`
to="eishi.yoshimoto@tri-stage.jp"
from="t-dsystem@tri-stage.jp"
subject=`echo -n "企画変更申請チェック" | base64 | tr -d '\n' | xargs printf '=?UTF-8?B?%s?=\n'`

cat << EOD | nkf -j -m0 | sendmail -t
From: ${from}
To: ${to}
Subject: ${subject}
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit

おつかれさまです。

企画変更申請のチェックツールより異常を検知しました。
検知内容：企画変更申請が承認済みにも関わらず、企画が変更されていません。

HOSOWAKUID, HOSOWAKURIREKIID, CURRENTFLAG, KIKAKUID, HOSODANID, TYPEID, WAKUSTATUS
$NGRECORED

--------- ---------------- ------ ------------------------------ ------------------------------
このメールは`ip a | grep "inet 192" | awk '{print $2}'`の`dirname $0`/`basename $0`より実行しています

EOD
}

getTFData
sqlplusTF_status=$?
if [[ $sqlplusTF_status -ne 0 ]]; then
    status=$ERROR_FLG
    exit $status
fi

if [[ -n `cat ${DISTFILE}` ]];then
  sendMailTF
else
  echo "empty"
fi

exit $status
