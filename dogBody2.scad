// 工字形 (I / H 形) 参数化模型 + 4 末端凹形 (U 形槽)
//  凹──────────────凹   <- 上横段两端：凹口向上
//  └──────┬──────┘
//         │            <- 中竖段 web_len
//    凸────┴────凸      <- 下横段两端：凹口向下（即凹形倒置）
//
// 单位：所有尺寸均为毫米 (mm)，1 OpenSCAD 单位 = 1 mm，导出 STL 直接按毫米

/* [基本参数] */
// 笔画粗细（三根线段的宽度/厚度）
thickness = 4;      // 粗细 (mm)
// 上横段长度
top_len    = 40;    // 第1根线段 (mm)
// 中竖段长度
web_len    = 50;    // 第2根线段 (mm)
// 下横段长度
bottom_len = 40;    // 第3根线段 (mm)

/* [3D 拉伸] */
// 工字形拉伸高度（设为 0 则只画 2D 平面）
depth = 6;          // (mm)
// 工字形相对末端凹形的 Z 轴偏移量（末端凹形固定在 Z 中心；正值使工字形向 +Z 移动）
beam_z = 0;         // (mm)
// 工字竖段(中竖段)中心沿 Z 轴的圆通孔直径（≤0 不开孔；需 < thickness 才完全落在竖段内）
web_hole_d = 3;     // (mm)

/* [末端凹形] —— 中空矩形盒，由 4 个参数控制 */
// 凹口宽度（X 方向，两壁之间的开口宽度）
notch_w = 6;        // (mm)
// 深度（Z 方向，凹盒拉伸厚度）；中空盒需 > 2*wall 才有 Z 向空腔；设为 0 则自动跟随工字形 depth
// 当前 12 > 梁 depth(6)：凹盒在 Z 两面各凸出 (12-6)/2 = 3mm（要与梁齐平需同时增大 depth 或减小 wall）
concave_d = 12;     // (mm)
// 高度（Y 方向，凹形伸出横段表面的净高度）
concave_h = 10;     // (mm)
// 壁厚（两侧壁 + ±Z 两面壁(−Z 底壁/+Z 顶壁)的厚度；外廓宽 = 凹口宽 + 2×壁厚；需 深度 > 2×壁厚 才有槽腔）
wall = 3;           // (mm)

/* [末端凹形 — 6 个面矩形通孔] */
// 凹形为六面封闭空心盒；在每个末端的 6 个面（左/右侧壁、底壁、背壁、顶壁、凹口壁）中心各开一个矩形通孔。
// 每个面单独设置：size=[长, 宽]；off=[沿“长”偏移, 沿“宽”偏移]（相对该面中心，mm）。
// 某面 size 的长或宽 <= 0 则该面不开孔。
hole_enable = true;

/* [Hidden] */
// 右侧壁 (+X 面)：长沿 Y、宽沿 Z；off=[ΔY, ΔZ]
hole_xp_size = [4, 3];
hole_xp_off  = [0, 0];
// 左侧壁 (−X 面)：长沿 Y、宽沿 Z；off=[ΔY, ΔZ]
hole_xn_size = [4, 3];
hole_xn_off  = [0, 0];
// 底壁 (背离开口的 Y 面)：长沿 X、宽沿 Z；off=[ΔX, ΔZ]
hole_yb_size = [4, 3];
hole_yb_off  = [0, 0];
// 背壁 (−Z 面)：长沿 X、宽沿 Y；off=[ΔX, ΔY]
hole_zn_size = [4, 3];
hole_zn_off  = [0, 0];
// 顶壁 (+Z 面，正上方那面)：长沿 X、宽沿 Y；off=[ΔX, ΔY]
hole_zp_size = [4, 3];
hole_zp_off  = [0, 0];
// 凹口壁 (开口侧 Y 面)：长沿 X、宽沿 Z；off=[ΔX, ΔZ]
hole_ym_size = [4, 3];
hole_ym_off  = [0, 0];

// ---- 工字形主体 ----
module i_beam_2d(thickness, top_len, web_len, bottom_len) {
    // 上横段：顶部居中
    translate([0, web_len/2 + thickness/2])
        square([top_len, thickness], center = true);

    // 中竖段：正中央
    square([thickness, web_len], center = true);

    // 下横段：底部居中
    translate([0, -(web_len/2 + thickness/2)])
        square([bottom_len, thickness], center = true);
}

module i_beam(thickness, top_len, web_len, bottom_len, depth = 0) {
    if (depth > 0)
        linear_extrude(height = depth, center = true)
            i_beam_2d(thickness, top_len, web_len, bottom_len);
    else
        i_beam_2d(thickness, top_len, web_len, bottom_len);
}

// ---- 末端凹形 (中空矩形盒) ----
// 思路：先把"实心外块"与工字并集，再统一挖"内腔"。这样内腔会同时穿过外块和
//      搭接处的横段材料——无论 thickness 多大，腔内都干净，不会被横段穿透。
// 几何约定：外廓宽 = notch_w + 2*wall；Y 向总高 = concave_h(净伸出) + thickness(搭接)；
//          六面各保留 wall 壁厚，形成封闭空心盒（需 Z 向 cd > 2*wall 才有腔）。

// 横段长度 = 两个凹形相对(内)侧之间的距离：凹形内侧边钉在 ±len/2，只向外伸出。
//   len=0 → 两凹形内侧紧贴、不重叠；len>0 → 内侧间距 = len。块中心 = 内侧 + overall_w/2。

// 4 个末端的实心外块（外廓矩形，未挖槽）
module end_blocks(top_len, web_len, bottom_len, thickness, notch_w, cd, concave_h, wall) {
    ty = web_len/2 + thickness/2;
    by = -(web_len/2 + thickness/2);
    overall_w = notch_w + 2 * wall;
    H = concave_h + thickness;
    // 上端：内侧边在 ±top_len/2，向外伸出
    for (s = [-1, 1])
        translate([s * (top_len/2 + overall_w/2), ty + concave_h/2, 0])
            cube([overall_w, H, cd], center = true);
    // 下端：内侧边在 ±bottom_len/2，向外伸出
    for (s = [-1, 1])
        translate([s * (bottom_len/2 + overall_w/2), by - concave_h/2, 0])
            cube([overall_w, H, cd], center = true);
}

// 4 个末端的凹槽切口（X 与对应外块同心；Z 向两面各留 wall：−Z 底壁 + 正上方 +Z 顶壁）
//   注意：需 cd > 2*wall 才有槽腔（两面各占 wall）；cd ≤ 2*wall 时槽腔归零、凹形变实心。
module end_slots(top_len, web_len, bottom_len, thickness, notch_w, cd, concave_h, wall) {
    ty = web_len/2 + thickness/2;
    by = -(web_len/2 + thickness/2);
    overall_w = notch_w + 2 * wall;
    H = concave_h + thickness;
    // 内腔居中，六面各留 wall：±X 侧壁、内侧 Y 底壁 + 外侧 Y 凹口壁、−Z 底壁 + +Z 顶壁 → 空心盒
    //   需 H > 2*wall 且 cd > 2*wall 才有内腔（否则该向变实心）。
    sz = [notch_w, H - 2 * wall, cd - 2 * wall];
    // 上端
    for (s = [-1, 1])
        translate([s * (top_len/2 + overall_w/2), ty + concave_h/2, 0])
            cube(sz, center = true);
    // 下端
    for (s = [-1, 1])
        translate([s * (bottom_len/2 + overall_w/2), by - concave_h/2, 0])
            cube(sz, center = true);
}

// 4 个末端凹形：在每个的 6 个面（±X 侧壁、内侧 Y 底壁、−Z 背壁、+Z 顶壁、外侧 Y 凹口壁）中心开矩形通孔。
//   每个面单独取 size=[长,宽] 与 off=[沿长偏移,沿宽偏移]（轴向映射见各 cube 注释）；
//   通孔深度略大于壁厚，确保切穿；某面长或宽 <= 0 则跳过。
module end_holes(top_len, web_len, bottom_len, thickness, notch_w, cd, concave_h, wall) {
    ty = web_len/2 + thickness/2;
    by = -(web_len/2 + thickness/2);
    overall_w = notch_w + 2 * wall;
    H = concave_h + thickness;
    eps = 0.1;
    t = wall + 2 * eps;                 // 通孔穿透深度（略大于壁厚）

    // 单个末端的 4 面孔：bx/by0 = 该末端中心；dir = 开口的 Y 朝向(+1 朝 +Y，-1 朝 −Y)
    module one_end(bx, by0, dir) {
        // 右侧壁 (+X 面)：孔面在 Y-Z 平面 → 长沿 Y、宽沿 Z；穿透沿 X；off=[ΔY, ΔZ]
        if (hole_xp_size[0] > 0 && hole_xp_size[1] > 0)
            translate([bx + (notch_w + wall)/2, by0 + hole_xp_off[0], hole_xp_off[1]])
                cube([t, hole_xp_size[0], hole_xp_size[1]], center = true);
        // 左侧壁 (−X 面)：孔面在 Y-Z 平面 → 长沿 Y、宽沿 Z；穿透沿 X；off=[ΔY, ΔZ]
        if (hole_xn_size[0] > 0 && hole_xn_size[1] > 0)
            translate([bx - (notch_w + wall)/2, by0 + hole_xn_off[0], hole_xn_off[1]])
                cube([t, hole_xn_size[0], hole_xn_size[1]], center = true);
        // 底壁 (背离开口的 Y 面，即 −dir 侧)：孔面在 X-Z 平面 → 长沿 X、宽沿 Z；穿透沿 Y；off=[ΔX, ΔZ]
        if (hole_yb_size[0] > 0 && hole_yb_size[1] > 0)
            translate([bx + hole_yb_off[0], by0 - dir * (H - wall)/2, hole_yb_off[1]])
                cube([hole_yb_size[0], t, hole_yb_size[1]], center = true);
        // 凹口壁 (开口侧 Y 面，即 +dir 侧)：孔面在 X-Z 平面 → 长沿 X、宽沿 Z；穿透沿 Y；off=[ΔX, ΔZ]
        if (hole_ym_size[0] > 0 && hole_ym_size[1] > 0)
            translate([bx + hole_ym_off[0], by0 + dir * (H - wall)/2, hole_ym_off[1]])
                cube([hole_ym_size[0], t, hole_ym_size[1]], center = true);
        // 背壁 (−Z 面)：孔面在 X-Y 平面 → 长沿 X、宽沿 Y；穿透沿 Z；off=[ΔX, ΔY]
        if (hole_zn_size[0] > 0 && hole_zn_size[1] > 0)
            translate([bx + hole_zn_off[0], by0 + hole_zn_off[1], -cd/2 + wall/2])
                cube([hole_zn_size[0], hole_zn_size[1], t], center = true);
        // 顶壁 (+Z 面)：孔面在 X-Y 平面 → 长沿 X、宽沿 Y；穿透沿 Z；off=[ΔX, ΔY]
        if (hole_zp_size[0] > 0 && hole_zp_size[1] > 0)
            translate([bx + hole_zp_off[0], by0 + hole_zp_off[1], cd/2 - wall/2])
                cube([hole_zp_size[0], hole_zp_size[1], t], center = true);
    }

    // 上端两个：开口朝 +Y
    for (s = [-1, 1])
        one_end(s * (top_len/2 + overall_w/2), ty + concave_h/2, +1);
    // 下端两个：开口朝 −Y
    for (s = [-1, 1])
        one_end(s * (bottom_len/2 + overall_w/2), by - concave_h/2, -1);
}

// ---- 渲染 ----
// 凹盒深度：0 表示跟随工字形 depth
concave_d_eff = (concave_d > 0) ? concave_d : depth;
// 中空盒护栏：三个方向的腔体尺寸都必须 > 0，否则该方向被壁厚塞满、凹盒变实心
assert(concave_d_eff         - 2 * wall > 0, "凹盒 Z 向无空腔：需 concave_d(或 depth) > 2*wall");
assert(concave_h + thickness - 2 * wall > 0, "凹盒 Y 向无空腔：需 concave_h + thickness > 2*wall");
assert(notch_w > 0, "凹盒 X 向无空腔：需 notch_w > 0");
difference() {
    union() {
        translate([0, 0, beam_z])
            i_beam(thickness, top_len, web_len, bottom_len, depth);
        end_blocks(top_len, web_len, bottom_len, thickness, notch_w, concave_d_eff, concave_h, wall);
    }
    end_slots(top_len, web_len, bottom_len, thickness, notch_w, concave_d_eff, concave_h, wall);
    if (hole_enable)
        end_holes(top_len, web_len, bottom_len, thickness, notch_w, concave_d_eff, concave_h, wall);
    // 工字竖段中心：沿 Z 轴的圆通孔（随工字一起在 Z 向偏移 beam_z）
    if (web_hole_d > 0)
        translate([0, 0, beam_z])
            cylinder(h = depth + 2, d = web_hole_d, center = true, $fn = 48);
}
