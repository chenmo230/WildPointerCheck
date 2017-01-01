#!/usr/bin/env xcrun swift

import Foundation

// 判断是否为文件夹
func isDirectory(atPath: String) -> Bool {
    var isDirectory: ObjCBool = ObjCBool(false)
    FileManager.default.fileExists(atPath: atPath, isDirectory: &isDirectory)
    
    return isDirectory.boolValue
}

func checkWildPointer(content: String, fileName: String) {
    // 正则表达式
    let pattern = "@property.*assign.*\\*.*;"
    //定义正则表达式
    let regular = try! NSRegularExpression(pattern: pattern, options:.caseInsensitive)
    let results = regular.matches(in: content, options: .reportProgress , range: NSMakeRange(0, content.characters.count))
    
    if results.count > 0 {
        print("In '\(fileName)':")
        //输出截取结果
        for result in results {
            print("\t", (content as NSString).substring(with: result.range))
        }
    }
    
}

// Swift3.0用CommandLine获取用户输入命令
// argc是参数个数
guard CommandLine.argc == 2 else {
    print("Argument cout error: it need a file path for argument!")
    exit(0)
}


// arguments是参数
let argv = CommandLine.arguments
let filePath = argv[1]

let fileManager = FileManager.default

var isDirectory: ObjCBool = ObjCBool(false)
guard fileManager.fileExists(atPath: filePath, isDirectory: &isDirectory) else {
    print("The '\(filePath)' file path is not exit!")
    exit(0)
}

guard fileManager.isReadableFile(atPath: filePath) else {
    print("The '\(filePath)' file path is not readable!")
    exit(0)
}


if isDirectory.boolValue {
    let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: filePath)!
    while let element = enumerator.nextObject() as? String {
        let absoluteFilePath = filePath + "/" + element
        
         // 文件夹不读取
        if isDirectory(atPath: absoluteFilePath) {
            continue
        }
        
        // 只读取.m文件和.h文件
        if element.hasSuffix(".h") || element.hasSuffix(".m") {
            if fileManager.isReadableFile(atPath: absoluteFilePath) {
                let url = URL(fileURLWithPath: absoluteFilePath)
                let content = try String(contentsOf: url, encoding: .utf8)
                checkWildPointer(content: content, fileName: element)
            }
        }
    }
} else {
    let url = URL(fileURLWithPath: filePath)
    let content = try String(contentsOf: url, encoding: .utf8)
    checkWildPointer(content: content, fileName: filePath)

}





//let process = Process()
//process.launchPath = "/bin/bash"
//process.arguments = ["-c", shell]
//
//process.launch()
