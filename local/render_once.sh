#!/usr/bin/env bash

# Assumption: planet.osm.pbf is pre-positioned in data/sources

set -x

echo 'Start Render'
date -u '+%Y-%m-%d %H:%M:%S'

mkdir -p data/sources
mkdir -p data/tmp

rm -rf data/sources/tmp*.osm.pbf

pyosmium-up-to-date -vvvv --size 10000 data/sources/planet.osm.pbf

docker run -e JAVA_TOOL_OPTIONS='-Xmx2g' -v "$(pwd)/data":/data \
  -u $(id -u ${USER}):$(id -g ${USER}) \
  ghcr.io/onthegomap/planetiler:latest \
  --download --download-only --only-fetch-wikidata

# Remove default downloaded OSM file
rm -rf data/sources/monaco.osm.pbf

PLANET="data/planet.pmtiles"

sudo docker run -e JAVA_TOOL_OPTIONS='-Xmx24g' -v "$(pwd)/data":/data \
    ghcr.io/onthegomap/planetiler:latest --area=planet --bounds=world \
    --output="/$PLANET" \
    --transportation_name_size_for_shield \
    --transportation_name_limit_merge \
    --boundary-osm-only \
    --storage=mmap --nodemap-type=array \
    --building_merge_z13=false \
    --languages=ab,ace,af,als,am,an,ar,arz,as,ast,az,az-Arab,az-cyr,azb,ba,bar,bat-smg,be,be-tarask,ber,bg,bm,bn,bo,bpy,br,bs,bxr,ca,cdo,ce,ceb,cho,chr,chy,ckb,co,cr,crh,crh-cyr,crk,cs,csb,cv,cy,da,dak,de,dsb,dv,dz,ee,egl,el,en,eo,es,et,eu,fa,fi,fil,fit,fo,fr,frr,full,fur,fy,ga,gag,gan,gcf,gd,gl,gn,gr,grc,gsw,gu,gv,ha,hak,hak-HJ,haw,he,hi,hif,hr,hsb,ht,hu,hur,hy,ia,id,ie,ilo,int,io,is,it,iu,ja,ja_kana,ja_rm,ja-Hira,ja-Latn,jv,ka,kab,kbd,ki,kk,kk-Arab,kl,km,kn,ko,ko-Hani,ko-Latn,krc,krl,ks,ku,kv,kw,ky,la,lb,left,lez,li,lij,lld,lmo,ln,lo,lrc,lt,lv,lzh,md,mdf,mez,mg,mhr,mi,mia,mk,ml,mn,mo,moh,mr,mrj,ms,ms-Arab,mt,mwl,my,myv,mzn,nah,nan,nan-HJ,nan-POJ,nan-TL,nds,ne,nl,nn,no,nov,nv,oc,oj,old,or,os,ota,pa,pam,pcd,pfl,pl,pms,pnb,pot,ps,pt,qu,right,rm,ro,ru,rue,rw,sah,sat,sc,scn,sco,sd,se,sh,si,sju,sk,sl,sma,smj,so,sq,sr,sr-Latn,su,sv,sw,syc,szl,ta,te,TEC,tg,th,th-Latn,ti,tk,tl,tr,tt,tt-lat,udm,ug,uk,ur,uz,uz-Arab,uz-cyr,uz-Cyrl,uz-Latn,vec,vi,vls,vo,wa,war,win,wiy,wo,wuu,xmf,yi,yo,yue,yue-Hant,yue-Latn,za,zgh,zh,zh_pinyin,zh_zhuyin,zh-Hans,zh-Hant,zh-Latn-pinyin,zu,zza

# Check if the file exists
if [[ ! -f "$PLANET" ]]; then
  echo "Error: File $PLANET does not exist."
  exit 1
fi

echo 'Uploading planet to s3 bucket'
aws s3 cp "$PLANET" s3://planet-pmtiles/

echo 'Removing local planet file'
rm -rf "$PLANET"

echo 'Invalidating the CDN cache'
aws cloudfront create-invalidation --distribution-id E1E7N0LWX2WY4E --invalidation-batch '{"Paths": {"Quantity": 1, "Items": ["/*"]}, "CallerReference": "invalidation-$(date +%Y%m%d%H%M%S)"}'

echo 'Render Complete'
date -u '+%Y-%m-%d %H:%M:%S'
