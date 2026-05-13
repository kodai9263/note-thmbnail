import AppKit
import Foundation

let width = 1280
let height = 670
let outputPath = CommandLine.arguments.dropFirst().first ?? "assets/generated/note-use-client-rsc-thumbnail.png"

let image = NSImage(size: NSSize(width: width, height: height))

func color(_ hex: UInt32, alpha: CGFloat = 1.0) -> NSColor {
    let red = CGFloat((hex >> 16) & 0xff) / 255.0
    let green = CGFloat((hex >> 8) & 0xff) / 255.0
    let blue = CGFloat(hex & 0xff) / 255.0
    return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
}

func roundedRect(_ rect: CGRect, radius: CGFloat, fill: NSColor, stroke: NSColor? = nil, lineWidth: CGFloat = 1) {
    let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    fill.setFill()
    path.fill()
    if let stroke {
        stroke.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
    }
}

func line(_ from: CGPoint, _ to: CGPoint, color: NSColor, width: CGFloat) {
    let path = NSBezierPath()
    path.move(to: from)
    path.line(to: to)
    color.setStroke()
    path.lineWidth = width
    path.stroke()
}

func circle(_ rect: CGRect, fill: NSColor) {
    let path = NSBezierPath(ovalIn: rect)
    fill.setFill()
    path.fill()
}

func drawText(_ text: String, rect: CGRect, size: CGFloat, weight: NSFont.Weight, color: NSColor, lineHeight: CGFloat? = nil, align: NSTextAlignment = .left) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = align
    paragraph.lineBreakMode = .byWordWrapping
    if let lineHeight {
        paragraph.minimumLineHeight = lineHeight
        paragraph.maximumLineHeight = lineHeight
    }
    let font = NSFont.systemFont(ofSize: size, weight: weight)
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: color,
        .paragraphStyle: paragraph
    ]
    NSString(string: text).draw(in: rect, withAttributes: attrs)
}

func drawPill(_ text: String, rect: CGRect, fill: NSColor, textColor: NSColor, size: CGFloat = 24) {
    roundedRect(rect, radius: rect.height / 2, fill: fill)
    drawText(text, rect: rect.insetBy(dx: 22, dy: 7), size: size, weight: .bold, color: textColor)
}

image.lockFocus()

// 背景は既存サムネと同じく、淡い紙色と薄いグリッドで技術メモ感を出す。
color(0xf8f4ea).setFill()
NSRect(x: 0, y: 0, width: width, height: height).fill()

for x in stride(from: -120, through: width + 120, by: 44) {
    line(CGPoint(x: CGFloat(x), y: 0), CGPoint(x: CGFloat(x - 210), y: CGFloat(height)), color: color(0xe8dec9, alpha: 0.65), width: 0.8)
}
for y in stride(from: 72, through: height, by: 96) {
    line(CGPoint(x: 0, y: CGFloat(y)), CGPoint(x: CGFloat(width), y: CGFloat(y)), color: color(0xeadfca, alpha: 0.55), width: 0.8)
}

circle(CGRect(x: -36, y: -58, width: 260, height: 260), fill: color(0xcfe0ff, alpha: 0.9))
circle(CGRect(x: 914, y: 400, width: 270, height: 270), fill: color(0xcfe9df, alpha: 0.88))
circle(CGRect(x: 976, y: -44, width: 290, height: 230), fill: color(0xf3cdbf, alpha: 0.8))

drawPill("React初心者メモ", rect: CGRect(x: 75, y: 565, width: 240, height: 46), fill: color(0x123b33), textColor: .white, size: 25)

drawText("先頭の\n「use client」は\nいつ必要？", rect: CGRect(x: 75, y: 330, width: 540, height: 205), size: 55, weight: .heavy, color: color(0x17231e), lineHeight: 67)

roundedRect(CGRect(x: 75, y: 315, width: 360, height: 13), radius: 6.5, fill: color(0x25bc86))
roundedRect(CGRect(x: 446, y: 315, width: 135, height: 13), radius: 6.5, fill: color(0xf27a46))

drawText("RSCの使い分けを整理してみた", rect: CGRect(x: 75, y: 266, width: 560, height: 44), size: 31, weight: .bold, color: color(0x26362f))
drawText("サーバーで動くものと、\nブラウザで動くものを分けて考える", rect: CGRect(x: 75, y: 210, width: 560, height: 58), size: 24, weight: .medium, color: color(0x55635e), lineHeight: 31)

roundedRect(CGRect(x: 75, y: 46, width: 510, height: 62), radius: 31, fill: .white.withAlphaComponent(0.92))
drawPill("Server: 取得・表示", rect: CGRect(x: 104, y: 59, width: 238, height: 36), fill: color(0xe9e4da), textColor: color(0x60706b), size: 19)
drawPill("Client: 操作・Hooks", rect: CGRect(x: 356, y: 59, width: 205, height: 36), fill: color(0x123b33), textColor: .white, size: 19)

let windowRect = CGRect(x: 672, y: 96, width: 540, height: 477)
roundedRect(windowRect.offsetBy(dx: 0, dy: -8), radius: 24, fill: color(0x9d907d, alpha: 0.16))
roundedRect(windowRect, radius: 24, fill: color(0xfffcf5), stroke: color(0xd3c7b3), lineWidth: 1.4)
roundedRect(CGRect(x: 672, y: 506, width: 540, height: 67), radius: 24, fill: color(0x203c34))
NSColor.clear.setFill()
NSRect(x: 672, y: 506, width: 540, height: 35).fill()
circle(CGRect(x: 697, y: 533, width: 18, height: 18), fill: color(0xf06451))
circle(CGRect(x: 727, y: 533, width: 18, height: 18), fill: color(0xf6c24a))
circle(CGRect(x: 757, y: 533, width: 18, height: 18), fill: color(0x35c77a))
roundedRect(CGRect(x: 807, y: 523, width: 260, height: 28), radius: 14, fill: color(0xffffff, alpha: 0.14))
drawText("react-server-components", rect: CGRect(x: 826, y: 525, width: 240, height: 26), size: 20, weight: .medium, color: color(0xcad9d4))

roundedRect(CGRect(x: 706, y: 400, width: 218, height: 96), radius: 17, fill: color(0x123b33))
drawText("Server\nComponent", rect: CGRect(x: 730, y: 423, width: 175, height: 58), size: 26, weight: .medium, color: .white, lineHeight: 31)
roundedRect(CGRect(x: 730, y: 411, width: 158, height: 14), radius: 7, fill: color(0x29c794))

roundedRect(CGRect(x: 964, y: 400, width: 212, height: 96), radius: 17, fill: color(0xe8f5ef), stroke: color(0x9ed8c6), lineWidth: 1.3)
drawText("Client\nComponent", rect: CGRect(x: 988, y: 423, width: 168, height: 58), size: 26, weight: .medium, color: color(0x183d35), lineHeight: 31)
roundedRect(CGRect(x: 988, y: 411, width: 150, height: 14), radius: 7, fill: color(0xf27a46))

line(CGPoint(x: 835, y: 360), CGPoint(x: 1040, y: 360), color: color(0x2f443a), width: 5)
let arrow = NSBezierPath()
arrow.move(to: CGPoint(x: 1040, y: 360))
arrow.line(to: CGPoint(x: 1016, y: 374))
arrow.line(to: CGPoint(x: 1016, y: 346))
arrow.close()
color(0x2f443a).setFill()
arrow.fill()

roundedRect(CGRect(x: 728, y: 216, width: 426, height: 92), radius: 16, fill: color(0xfff7d9), stroke: color(0xe4bd50), lineWidth: 1.4)
drawText("必要なJSだけ送る", rect: CGRect(x: 754, y: 259, width: 380, height: 35), size: 31, weight: .bold, color: color(0x173d35))
drawText("操作が必要な部分だけクライアントへ", rect: CGRect(x: 754, y: 228, width: 380, height: 28), size: 22, weight: .medium, color: color(0x4d5f58))

roundedRect(CGRect(x: 1014, y: 548, width: 178, height: 116), radius: 26, fill: .white.withAlphaComponent(0.94))
drawText("判断基準", rect: CGRect(x: 1038, y: 626, width: 132, height: 28), size: 22, weight: .bold, color: color(0x293830), align: .center)
roundedRect(CGRect(x: 1038, y: 608, width: 128, height: 8), radius: 4, fill: color(0x25bc86))
drawText("操作あり？\nHooksあり？", rect: CGRect(x: 1038, y: 566, width: 132, height: 40), size: 19, weight: .medium, color: color(0x3e4e49), lineHeight: 22, align: .center)

image.unlockFocus()

guard let tiff = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiff),
      let png = bitmap.representation(using: .png, properties: [:]) else {
    fatalError("PNGの生成に失敗しました")
}

try FileManager.default.createDirectory(atPath: (outputPath as NSString).deletingLastPathComponent, withIntermediateDirectories: true)
try png.write(to: URL(fileURLWithPath: outputPath))
print(outputPath)
