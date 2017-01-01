本脚本是一个Swift脚本，用来检查oc代码是是查找类似“可能”引发野指针崩溃的代码：
```
@property (nonatomic, assign) NSString *name;
```
#操作步骤
1、下载脚本
```
$ git clone git@github.com:chenmo230/WildPointerCheck.git
```
2、更改权限
```
$ chmod +x WildPointerCheck.swift
```
3、执行
```
$ ./WildPointerCheck Object-C/Project/Path
```