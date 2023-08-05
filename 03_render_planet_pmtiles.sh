#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

sudo touch logs.txt
sudo tail -f logs.txt | sudo nc seashells.io 1337 > /tmp/seashells & sleep 10

run() {
  set -x
  sudo docker run -e JAVA_TOOL_OPTIONS='-Xmx30g' -v "$(pwd)/data":/data \
    ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world \
    --output=/data/planet.pmtiles \
    --transportation_name_size_for_shield \
    --transportation_name_limit_merge \
    --boundary-osm-only \
    --storage=mmap --nodemap-type=array \
    --building_merge_z13=false \
    --languages=ab,ace,af,als,am,an,ar,arz,as,ast,az,az-Arab,az-cyr,azb,ba,bar,bat-smg,be,be-tarask,ber,bg,bm,bn,bo,bpy,br,bs,bxr,ca,cdo,ce,ceb,cho,chr,chy,ckb,co,cr,crh,crh-cyr,crk,cs,csb,cv,cy,da,dak,de,dsb,dv,dz,ee,egl,el,en,eo,es,et,eu,fa,fi,fil,fit,fo,fr,frr,full,fur,fy,ga,gag,gan,gcf,gd,gl,gn,gr,grc,gsw,gu,gv,ha,hak,hak-HJ,haw,he,hi,hif,hr,hsb,ht,hu,hur,hy,ia,id,ie,ilo,int,io,is,it,iu,ja,ja_kana,ja_rm,ja-Hira,ja-Latn,jv,ka,kab,kbd,ki,kk,kk-Arab,kl,km,kn,ko,ko-Hani,ko-Latn,krc,krl,ks,ku,kv,kw,ky,la,lb,left,lez,li,lij,lld,lmo,ln,lo,lrc,lt,lv,lzh,md,mdf,mez,mg,mhr,mi,mia,mk,ml,mn,mo,moh,mr,mrj,ms,ms-Arab,mt,mwl,my,myv,mzn,nah,nan,nan-HJ,nan-POJ,nan-TL,nds,ne,nl,nn,no,nov,nv,oc,oj,old,or,os,ota,pa,pam,pcd,pfl,pl,pms,pnb,pot,ps,pt,qu,right,rm,ro,ru,rue,rw,sah,sat,sc,scn,sco,sd,se,sh,si,sju,sk,sl,sma,smj,so,sq,sr,sr-Latn,su,sv,sw,syc,szl,ta,te,TEC,tg,th,th-Latn,ti,tk,tl,tr,tt,tt-lat,udm,ug,uk,ur,uz,uz-Arab,uz-cyr,uz-Cyrl,uz-Latn,vec,vi,vls,vo,wa,war,win,wiy,wo,wuu,xmf,yi,yo,yue,yue-Hant,yue-Latn,za,zgh,zh,zh_pinyin,zh_zhuyin,zh-Hans,zh-Hant,zh-Latn-pinyin,zu,zza
  sudo time aws s3 cp /home/ubuntu/build/data/planet.pmtiles s3://planet-pmtiles/planet.pmtiles
}

run | sudo tee -a logs.txt
