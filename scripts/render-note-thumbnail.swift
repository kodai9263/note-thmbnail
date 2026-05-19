import AppKit
import Foundation

struct NoteMetadata: Decodable {
    let key: String
    let url: String
    let title: String
    let bodyText: String
}

let metadataPath = CommandLine.arguments.dropFirst().first ?? "logs/last-note.json"
let outputPath = CommandLine.arguments.dropFirst().dropFirst().first ?? "assets/generated/note-thumbnail.png"
let data = try Data(contentsOf: URL(fileURLWithPath: metadataPath))
let note = try JSONDecoder().decode(NoteMetadata.self, from: data)

let width = 1280
let height = 670
let image = NSImage(size: NSSize(width: width, height: height))

func color(_ hex: UInt32, alpha: CGFloat = 1.0) -> NSColor {
    NSColor(
        calibratedRed: CGFloat((hex >> 16) & 0xff) / 255.0,
        green: CGFloat((hex >> 8) & 0xff) / 255.0,
        blue: CGFloat(hex & 0xff) / 255.0,
        alpha: alpha
    )
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
    let attrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: size, weight: weight),
        .foregroundColor: color,
        .paragraphStyle: paragraph
    ]
    NSString(string: text).draw(in: rect, withAttributes: attrs)
}

func drawPill(_ text: String, rect: CGRect, fill: NSColor, textColor: NSColor, size: CGFloat = 20) {
    roundedRect(rect, radius: rect.height / 2, fill: fill)
    drawText(text, rect: rect.insetBy(dx: 22, dy: 7), size: size, weight: .bold, color: textColor)
}

func slugOutputName(for note: NoteMetadata) -> String {
    if note.title.contains("データフェッチ") {
        return "note-data-fetch-patterns-thumbnail.png"
    }
    if note.title.localizedCaseInsensitiveContains("use client") {
        return "note-use-client-rsc-thumbnail.png"
    }
    return "note-\(note.key)-thumbnail.png"
}

let isDataFetch = note.title.contains("データフェッチ")
let isUseClient = note.title.localizedCaseInsensitiveContains("use client")

let mainTitle: String
let subTitle: String
let lead: String
let topBadge: String
let cardA: String
let cardB: String
let cardC: String
let calloutTitle: String
let calloutBody: String
let addressText: String

if isDataFetch {
    mainTitle = "データフェッチは\nどこで取る？"
    subTitle = "3つの取得パターンを整理してみた"
    lead = "サーバーで取得すると、\n速さ・SEO・安全性を整理しやすい"
    topBadge = "取得パターン"
    cardA = "ORM\nDB直結"
    cardB = "Parallel\n同時取得"
    cardC = "Stream\n順番表示"
    calloutTitle = "速い・SEO・安全"
    calloutBody = "取得場所とキャッシュを設計する"
    addressText = "data-fetching-patterns"
} else if isUseClient {
    mainTitle = "先頭の\n「use client」は\nいつ必要？"
    subTitle = "RSCの使い分けを整理してみた"
    lead = "サーバーで動くものと、\nブラウザで動くものを分けて考える"
    topBadge = "判断基準"
    cardA = "Server\nComponent"
    cardB = "Client\nComponent"
    cardC = "Boundary\n境界を意識"
    calloutTitle = "必要なJSだけ送る"
    calloutBody = "操作が必要な部分だけクライアントへ"
    addressText = "react-server-components"
} else {
    mainTitle = note.title.replacingOccurrences(of: "を整理してみた", with: "\n整理してみた")
    subTitle = "React初心者メモ"
    lead = "記事の要点を、\nあとから見返しやすく整理する"
    topBadge = "学習メモ"
    cardA = "Before\n疑問"
    cardB = "After\n整理"
    cardC = "Next\n深掘り"
    calloutTitle = "要点を一枚で整理"
    calloutBody = "仕組みと使いどころをつなげる"
    addressText = note.key
}

image.lockFocus()

// 既存サムネと同じ紙色・薄いグリッド・淡い円でシリーズ感を保つ。
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
drawText(mainTitle, rect: CGRect(x: 75, y: 330, width: 560, height: 205), size: isDataFetch ? 57 : 55, weight: .heavy, color: color(0x17231e), lineHeight: 68)

roundedRect(CGRect(x: 75, y: 315, width: 360, height: 13), radius: 6.5, fill: color(0x25bc86))
roundedRect(CGRect(x: 446, y: 315, width: 135, height: 13), radius: 6.5, fill: color(0xf27a46))

drawText(subTitle, rect: CGRect(x: 75, y: 266, width: 560, height: 44), size: 31, weight: .bold, color: color(0x26362f))
drawText(lead, rect: CGRect(x: 75, y: 210, width: 560, height: 58), size: 24, weight: .medium, color: color(0x55635e), lineHeight: 31)

let windowRect = CGRect(x: 672, y: 96, width: 540, height: 477)
roundedRect(windowRect.offsetBy(dx: 0, dy: -8), radius: 24, fill: color(0x9d907d, alpha: 0.16))
roundedRect(windowRect, radius: 24, fill: color(0xfffcf5), stroke: color(0xd3c7b3), lineWidth: 1.4)
roundedRect(CGRect(x: 672, y: 506, width: 540, height: 67), radius: 24, fill: color(0x203c34))
circle(CGRect(x: 697, y: 533, width: 18, height: 18), fill: color(0xf06451))
circle(CGRect(x: 727, y: 533, width: 18, height: 18), fill: color(0xf6c24a))
circle(CGRect(x: 757, y: 533, width: 18, height: 18), fill: color(0x35c77a))
roundedRect(CGRect(x: 807, y: 523, width: 260, height: 28), radius: 14, fill: color(0xffffff, alpha: 0.14))
drawText(addressText, rect: CGRect(x: 826, y: 525, width: 240, height: 26), size: 20, weight: .medium, color: color(0xcad9d4))

roundedRect(CGRect(x: 706, y: 398, width: 142, height: 106), radius: 17, fill: color(0x123b33))
drawText(cardA, rect: CGRect(x: 729, y: 425, width: 100, height: 62), size: 24, weight: .bold, color: .white, lineHeight: 29)
roundedRect(CGRect(x: 728, y: 412, width: 96, height: 13), radius: 6.5, fill: color(0x29c794))

roundedRect(CGRect(x: 870, y: 398, width: 142, height: 106), radius: 17, fill: color(0xe8f5ef), stroke: color(0x9ed8c6), lineWidth: 1.3)
drawText(cardB, rect: CGRect(x: 890, y: 425, width: 108, height: 62), size: 23, weight: .bold, color: color(0x183d35), lineHeight: 28)
roundedRect(CGRect(x: 892, y: 412, width: 96, height: 13), radius: 6.5, fill: color(0xf0c34f))

roundedRect(CGRect(x: 1034, y: 398, width: 142, height: 106), radius: 17, fill: color(0xf9efe8), stroke: color(0xe7b59a), lineWidth: 1.3)
drawText(cardC, rect: CGRect(x: 1052, y: 425, width: 110, height: 62), size: 23, weight: .bold, color: color(0x183d35), lineHeight: 28)
roundedRect(CGRect(x: 1055, y: 412, width: 96, height: 13), radius: 6.5, fill: color(0xf27a46))

line(CGPoint(x: 835, y: 350), CGPoint(x: 1040, y: 350), color: color(0x2f443a), width: 5)
let arrow = NSBezierPath()
arrow.move(to: CGPoint(x: 1040, y: 350))
arrow.line(to: CGPoint(x: 1016, y: 364))
arrow.line(to: CGPoint(x: 1016, y: 336))
arrow.close()
color(0x2f443a).setFill()
arrow.fill()

roundedRect(CGRect(x: 728, y: 216, width: 426, height: 92), radius: 16, fill: color(0xfff7d9), stroke: color(0xe4bd50), lineWidth: 1.4)
drawText(calloutTitle, rect: CGRect(x: 754, y: 259, width: 380, height: 35), size: 31, weight: .bold, color: color(0x173d35))
drawText(calloutBody, rect: CGRect(x: 754, y: 228, width: 380, height: 28), size: 22, weight: .medium, color: color(0x4d5f58))

roundedRect(CGRect(x: 1014, y: 548, width: 178, height: 116), radius: 26, fill: .white.withAlphaComponent(0.94))
drawText(topBadge, rect: CGRect(x: 1038, y: 626, width: 132, height: 28), size: 22, weight: .bold, color: color(0x293830), align: .center)
roundedRect(CGRect(x: 1038, y: 608, width: 128, height: 8), radius: 4, fill: color(0x25bc86))
drawText(isDataFetch ? "速い・SEO\n安全" : "操作あり？\nHooksあり？", rect: CGRect(x: 1038, y: 562, width: 132, height: 44), size: 19, weight: .medium, color: color(0x3e4e49), lineHeight: 21, align: .center)

image.unlockFocus()

guard let tiff = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiff),
      let png = bitmap.representation(using: .png, properties: [:]) else {
    fatalError("PNGの生成に失敗しました")
}

let finalOutput = outputPath.hasSuffix("/") ? "\(outputPath)\(slugOutputName(for: note))" : outputPath
try FileManager.default.createDirectory(atPath: (finalOutput as NSString).deletingLastPathComponent, withIntermediateDirectories: true)
try png.write(to: URL(fileURLWithPath: finalOutput))
print(finalOutput)
