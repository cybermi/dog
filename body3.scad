// body3.scad
// 工字形结构 —— 两条水平横梁 + 中间竖梁，四端各带一个矩形块
//   I-beam (工) frame with a rectangular block at each of the 4 ends
// 单位: mm

// ================= 参数 =================
// 矩形块 (四端)
box_l = 22;   // X 方向长度
box_w = 22;   // Y 方向宽度
box_h = 20;   // Z 方向高度

// 连接梁
bar_w = 7;    // 梁宽度
bar_h = 7;    // 梁高度 (Z 厚度)

// 整体跨距 (按矩形块中心计)
span_x = 62;  // 左右两块中心间距 = 上/下横梁长度
span_y = 52;  // 上下两横梁中心间距 = 竖梁长度

// ================= 模块 =================
// 矩形块, 底面落在 z=0
module rbox(cx, cy) {
    translate([cx, cy, box_h / 2])
        cube([box_l, box_w, box_h], center = true);
}

// 水平横梁 (沿 X), 底面落在 z=0; 长度取中心间距以嵌入两端方块
module hbar(cy) {
    translate([0, cy, bar_h / 2])
        cube([span_x, bar_w, bar_h], center = true);
}

// 中间竖梁 (沿 Y, 居中), 底面落在 z=0; 长度取上下横梁间距以连接两梁
module vbar() {
    translate([0, 0, bar_h / 2])
        cube([bar_w, span_y, bar_h], center = true);
}

// ================= 装配 =================
union() {
    // 四个矩形块 (四端)
    rbox(-span_x / 2,  span_y / 2);   // 左上
    rbox( span_x / 2,  span_y / 2);   // 右上
    rbox(-span_x / 2, -span_y / 2);   // 左下
    rbox( span_x / 2, -span_y / 2);   // 右下

    // 工字: 上横梁 + 下横梁 + 中间竖梁
    hbar( span_y / 2);   // 上横梁
    hbar(-span_y / 2);   // 下横梁
    vbar();              // 中间竖梁
}
