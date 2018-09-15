#! /bin/bash

PROJ=""
POD_SPEC="${PROJ}.podspec"
POD_REPO="master"
VERSION=$1
COMPANY="jumpingfrog0"


echo "==> 准备提交 $PROJ 工程, 版本号：$VERSION"

if [ ! -n $VERSION ]
then
	echo "$0 [ERROR] 缺少 version 参数"
	exit 0
fi

echo "==> 生成 appledoc 文档"
appledoc -o ./Docs \
--project-name $PROJ \
--project-company "$COMPANY" \
--no-create-docset \
--clean-output \
--use-code-order \
./$PROJ/Classes

echo "==> 修改 $POD_SPEC 版本号: $VERSION"
sed -i '' "11,11s/'.*'/'$VERSION'/g" $POD_SPEC

echo "==> 提交 repo 修改"
git add .
git commit -m "commit $PROJ version $VERSION"
git push origin master

echo "==> 提交 tag $VERSION"
git tag -d $VERSION
git tag $VERSION -m "tag: $VERSION"
git push --force origin refs/tags/$VERSION:refs/tags/$VERSION

pod trunk push $POD_SPEC --allow-warnings --verbose
