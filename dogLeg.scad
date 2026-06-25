// 直U支架 (Straight U Bracket) —— 舵机U型支架，参数化
//
//        ┌───────────┐   <- 末端/顶板 (end), 壁厚 end_wall
//        │ ·  (O)  · │
//        │           │
//    两侧 │           │ 两侧
//   (legs)│           │(legs)  壁厚 side_wall
//        │ ·  (O)  · │   <- 圆头 + 孔组
//         \         /
//          \_______/
//
// 单位：mm。所有尺寸均为浮点，支持小数点后两位（如 3.25）；Customizer 中以 0.01 步进。
// 两侧(legs)与末端(end)的壁厚、孔组(孔径/螺栓圆/孔数/起始角/对焦孔/对角孔)均可独立配置。
// 孔组依据参考图：中心 Ø7，外加 Ø14 螺栓圆上均布 8 孔（轴向 Ø2 / 对角 Ø3 交替）。
// 三个标注由此而来：14mm = 螺栓圆直径；10mm(竖/底) = 45°相邻孔间距 = 2·7·sin45° ≈ 9.9。

/* [壁厚 —— 可分别设置] */
// 两侧(腿)壁厚 (mm)
side_wall = 3.00;    // [0.1:0.01:20]
// 末端(顶板)壁厚 (mm)
end_wall  = 3.00;    // [0.1:0.01:20]

/* [两侧孔 —— 腿面孔组 (legs)] */
// 总开关：两侧腿面是否开孔
holes_on_legs = true;
// 中心(对焦)孔 Ø (mm)
side_d_center = 7.00;        // [0:0.01:50]
// 轴向孔 Ø (mm)
side_d_axis = 2.00;         // [0:0.01:20]
// 对角孔 Ø (mm)
side_d_diag = 3.00;         // [0:0.01:20]
// 螺栓圆直径 Ø (mm)
side_bolt_circle_d = 14.00; // [0:0.01:60]
// 圆周均布孔数 (整数)
side_n_holes = 8;           // [2:64]
// 起始角度 (度)
side_hole_start_a = 0.00;   // [0:0.01:360]
// 对焦孔(中心)开关
side_center_hole = true;
// 对角孔(奇序号)开关
side_diag_holes = true;

/* [末端孔 —— 顶板孔组 (end)] */
// 总开关：顶板是否开孔
holes_on_top = true;
// 中心(对焦)孔 Ø (mm)
end_d_center = 7.00;        // [0:0.01:50]
// 轴向孔 Ø (mm)
end_d_axis = 2.00;         // [0:0.01:20]
// 对角孔 Ø (mm)
end_d_diag = 3.00;         // [0:0.01:20]
// 螺栓圆直径 Ø (mm)
end_bolt_circle_d = 14.00; // [0:0.01:60]
// 圆周均布孔数 (整数)
end_n_holes = 8;           // [2:64]
// 起始角度 (度)
end_hole_start_a = 0.00;   // [0:0.01:360]
// 对焦孔(中心)开关
end_center_hole = true;
// 对角孔(奇序号)开关
end_diag_holes = true;

/* [支架外形] —— 图中未标注者为估计值，可调 */
// 腿长(含圆头)，图中 41mm (mm)
leg_length    = 41.00; // [1:0.01:300]
// 宽度(图中未标注；须 ≥ 孔图范围约 17mm) (mm)
bracket_width = 24.00; // [1:0.01:200]
// 两腿内侧间距(容纳舵机；图中未标注) (mm)
gap           = 18.00; // [0:0.01:200]

/* [末端倒角 —— 两个轴向可分别设置] */
// X 向倒角：宽度(bracket_width)两端边(X=±bw/2, 沿 Y)的 45° 倒角尺寸（0=关闭） (mm)
end_chamfer_x = 3.00;  // [0:0.01:20]
// Y 向倒角：深度(D)两端边(Y=±D/2, 沿 X)的 45° 倒角尺寸（0=关闭） (mm)
end_chamfer_y = 3.00;  // [0:0.01:20]

/* [内侧倒角] */
// U 型内侧两条边（两侧壁内表面与底面相交处）的 45° 加强倒角尺寸（0=关闭） (mm)
inner_chamfer = 2.00;  // [0:0.01:20]

/* [末端凸点] —— 顶板外表面(Z=0)中心单个凸起，圆形或矩形 */
// 总开关：末端(顶板)外表面中心是否添加凸点
end_bump_on = true;
// 凸点形状：0=圆形(圆柱), 1=矩形(方块)
end_bump_shape = 0;     // [0:圆形, 1:矩形]
// 凸点直壁高度(沿 +Z；倒角另在其上叠加，总高=高度+倒角) (mm)
end_bump_h = 1.50;      // [0.1:0.01:300]
// 圆形凸点直径 Ø (mm)
end_bump_d = 10.00;     // [0.1:0.01:300]
// 矩形凸点 X 边长 (mm)
end_bump_x = 10.00;     // [0.1:0.01:300]
// 矩形凸点 Y 边长 (mm)
end_bump_y = 10.00;     // [0.1:0.01:300]
// 凸点顶边 45° 倒角尺寸（0=关闭；叠加在直壁高度之上，总高=高度+倒角；自动限制在截面内半径内） (mm)
end_bump_chamfer = 1.00; // [0:0.01:150]
// 凸点根部 45° 倒角尺寸（0=关闭；在根部向外加斜裙加固，底部外扩 r、高度 r；上限=直壁高度） (mm)
end_bump_root = 1.00;    // [0:0.01:150]

/* [末端凸点顶部再凸点] */
// 在主末端凸点的顶部端面中心再添加一个较小凸点。
end_tip_bump_on = true;
end_tip_bump_shape = 0;      // [0:圆形, 1:矩形]
// 高度为正数时生成凸点；为负数时从主凸点顶部向下打孔，孔深=绝对值。
end_tip_bump_h = 1.00;       // [-300:0.01:300]
end_tip_bump_d = 5.00;       // [0.1:0.01:300]
end_tip_bump_x = 5.00;       // [0.1:0.01:300]
end_tip_bump_y = 5.00;       // [0.1:0.01:300]
end_tip_bump_chamfer = 0.50; // [0:0.01:150]
end_tip_bump_root = 0.50;    // [0:0.01:150]

/* [渲染精度] */
$fn = 64;
eps = 0.05;

// ---- 派生量 ----
r_round = bracket_width / 2;            // 圆头半径
zc_leg  = -(leg_length - r_round);      // 腿上孔组中心 Z（即圆头圆心）
D       = gap + 2 * side_wall;          // 顶板深度(Y 方向)，两腿外缘对齐

// ---- 孔组：2D 圆（中心在原点），全部参数化以便两侧/末端独立配置 ----
//   bcd=螺栓圆直径, n=孔数, a0=起始角, dc=中心孔径, da=轴向孔径, dd=对角孔径,
//   do_center=画中心(对焦)孔, do_diag=画对角孔
module pattern_circles(bcd, n, a0, dc, da, dd, do_center, do_diag) {
    bcr = bcd / 2;
    if (do_center)
        circle(d = dc);
    for (i = [0 : n - 1]) {
        is_diag = (i % 2 == 1);   // 奇序号 = 对角孔
        if (!is_diag || do_diag) {
            a = a0 + i * 360 / n;
            translate([bcr * cos(a), bcr * sin(a)])
                circle(d = (i % 2 == 0) ? da : dd);
        }
    }
}

// ---- 实体 ----
// 单条腿：直段(方块) + 圆头(沿 Y 的圆柱)，腿厚 = side_wall 沿 Y。
// ys = 腿在 Y 方向的起始坐标。
module leg(ys) {
    // 直段：自顶板(Z=0)向下到圆心 zc_leg
    translate([-bracket_width/2, ys, zc_leg])
        cube([bracket_width, side_wall, leg_length - r_round]);
    // 圆头：轴沿 +Y 的圆柱
    translate([0, ys, zc_leg])
        rotate([-90, 0, 0])
            cylinder(h = side_wall, r = r_round);
}

module top_plate() {
    translate([-bracket_width/2, -D/2, -end_wall])
        cube([bracket_width, D, end_wall]);
}

// ---- 内侧加强倒角 ----
// 单条内侧倒角：U 型一侧壁内表面与底面(顶板内表面 Z=-end_wall)相交处的 45° 三角形，
// 沿 X 方向贯穿整宽 bracket_width。截面三顶点(世界 Y,Z)：
//   角点(gap/2, -end_wall)、沿底面(gap/2-c, -end_wall)、沿壁面(gap/2, -end_wall-c)。
// 经 rotate([0,90,0]) 把 linear_extrude 的挤出方向(局部 +Z)转到世界 +X：
//   局部点(px,py) → 世界(_, py, -px)，故下方多项式用 (end_wall, gap/2) 表示该角点。
module inner_chamfer_one() {
    c = inner_chamfer;
    translate([-bracket_width/2, 0, 0])
        rotate([0, 90, 0])
            linear_extrude(height = bracket_width)
                polygon([[end_wall,     gap/2    ],
                         [end_wall,     gap/2 - c],
                         [end_wall + c, gap/2    ]]);
}
module inner_chamfers() {
    if (inner_chamfer > 0) {
        inner_chamfer_one();                    // 右内侧 (Y=+gap/2)
        mirror([0, 1, 0]) inner_chamfer_one();  // 左内侧 (Y=-gap/2)
    }
}

// ---- 末端中心凸点 ----
// 凸点二维截面：圆形或矩形，居中于原点。
module bump_2d() {
    if (end_bump_shape == 0)
        circle(d = end_bump_d);                          // 圆形
    else
        square([end_bump_x, end_bump_y], center = true); // 矩形
}
module tip_bump_2d() {
    if (end_tip_bump_shape == 0)
        circle(d = end_tip_bump_d);
    else
        square([end_tip_bump_x, end_tip_bump_y], center = true);
}
// 顶板外表面(Z=0)中心的单个凸起：直壁段高度 = end_bump_h(沿 +Z)，形状由 end_bump_shape 选择。
// 顶边 45° 倒角(end_bump_chamfer=c)叠加在直壁之上：从全截面(z=h) loft 到内缩 c 的截面(z=h+c)。
// 根部 45° 倒角(end_bump_root=rc)在底部向外加斜裙：从外扩 rc 的截面(z=0) loft 到全截面(z=rc)。
// 因此总高 = end_bump_h + c。顶倒角上限 = 截面内半径；根倒角高度上限 = 直壁高度。
// 底部下沉 eps 与顶板搭接，避免共面缝隙。
module end_bump() {
    if (end_bump_on && end_bump_h > 0) {
        inr = (end_bump_shape == 0) ? end_bump_d/2
                                    : min(end_bump_x, end_bump_y)/2;
        c  = min(max(end_bump_chamfer, 0), max(0, inr - eps));
        rc = min(max(end_bump_root, 0), end_bump_h);
        // 直壁段：从底(-eps)到顶(h)，完整高度不被倒角占用
        translate([0, 0, -eps])
            linear_extrude(height = end_bump_h + eps)
                bump_2d();
        // 顶部倒角段：叠加在直壁之上，从全截面(z=h) loft 到内缩 c 的截面(z=h+c)
        if (c > 0)
            hull() {
                translate([0, 0, end_bump_h - eps])
                    linear_extrude(height = eps) bump_2d();
                translate([0, 0, end_bump_h + c - eps])
                    linear_extrude(height = eps) offset(delta = -c) bump_2d();
            }
        // 根部倒角段：在根部向外加斜裙，从外扩 rc 的截面(z=-eps) loft 到全截面(z=rc)
        if (rc > 0)
            hull() {
                translate([0, 0, -eps])
                    linear_extrude(height = eps) offset(delta = rc) bump_2d();
                translate([0, 0, rc - eps])
                    linear_extrude(height = eps) bump_2d();
            }
    }
}

module end_tip_bump() {
    if (end_bump_on && end_tip_bump_on && end_tip_bump_h > 0) {
        parent_inr = (end_bump_shape == 0) ? end_bump_d/2
                                           : min(end_bump_x, end_bump_y)/2;
        parent_c = min(max(end_bump_chamfer, 0), max(0, parent_inr - eps));
        inr = (end_tip_bump_shape == 0) ? end_tip_bump_d/2
                                        : min(end_tip_bump_x, end_tip_bump_y)/2;
        c  = min(max(end_tip_bump_chamfer, 0), max(0, inr - eps));
        rc = min(max(end_tip_bump_root, 0), end_tip_bump_h);

        translate([0, 0, end_bump_h + parent_c]) {
            translate([0, 0, -eps])
                linear_extrude(height = end_tip_bump_h + eps)
                    tip_bump_2d();

            if (c > 0)
                hull() {
                    translate([0, 0, end_tip_bump_h - eps])
                        linear_extrude(height = eps) tip_bump_2d();
                    translate([0, 0, end_tip_bump_h + c - eps])
                        linear_extrude(height = eps) offset(delta = -c) tip_bump_2d();
                }

            if (rc > 0)
                hull() {
                    translate([0, 0, -eps])
                        linear_extrude(height = eps) offset(delta = rc) tip_bump_2d();
                    translate([0, 0, rc - eps])
                        linear_extrude(height = eps) tip_bump_2d();
                }
        }
    }
}

module end_tip_hole() {
    if (end_bump_on && end_tip_bump_on && end_tip_bump_h < 0) {
        parent_inr = (end_bump_shape == 0) ? end_bump_d/2
                                           : min(end_bump_x, end_bump_y)/2;
        parent_c = min(max(end_bump_chamfer, 0), max(0, parent_inr - eps));
        parent_top_z = end_bump_h + parent_c;
        hole_depth = -end_tip_bump_h;

        translate([0, 0, parent_top_z - hole_depth - eps])
            linear_extrude(height = hole_depth + 2 * eps)
                tip_bump_2d();
    }
}

module bracket_solid() {
    union() {
        top_plate();
        leg(gap/2);                    // 右腿
        leg(-gap/2 - side_wall);       // 左腿
        inner_chamfers();              // U 型内侧两条边的加强倒角
    }
}

// ---- 钻孔 ----
// 腿面孔：孔组在 X-Z 面，沿 Y 钻穿。ys = 腿面起始 Y。
module leg_holes(ys) {
    translate([0, ys - eps, zc_leg])
        rotate([-90, 0, 0])
            linear_extrude(height = side_wall + 2 * eps)
                pattern_circles(side_bolt_circle_d, side_n_holes, side_hole_start_a,
                                side_d_center, side_d_axis, side_d_diag,
                                side_center_hole, side_diag_holes);
}

// 顶板孔：孔组在 X-Y 面，沿 Z 钻穿。
module top_holes() {
    translate([0, 0, -end_wall - eps])
        linear_extrude(height = end_wall + 2 * eps)
            pattern_circles(end_bolt_circle_d, end_n_holes, end_hole_start_a,
                            end_d_center, end_d_axis, end_d_diag,
                            end_center_hole, end_diag_holes);
}

// ---- 末端倒角 ----
// 45° 半空间切刀：切去 x+z>k 的部分（顶板外平面 +X 一侧的上外棱）
module half_cut_xplus(k) {
    BIG = 1000;
    translate([k, 0, 0])
        rotate([0, -45, 0])
            translate([0, -BIG/2, -BIG/2])
                cube(BIG);
}
// 45° 半空间切刀：切去 y+z>k 的部分（顶板外平面 +Y 一侧的上外棱）
module half_cut_yplus(k) {
    BIG = 1000;
    translate([0, k, 0])
        rotate([45, 0, 0])
            translate([-BIG/2, 0, -BIG/2])
                cube(BIG);
}
// 顶板外平面(z=0)四条边切 45° 楔形（作用于整体，使腿侧折角也一并倒角）。
// X/Y 两个轴向独立：end_chamfer_x 管 X=±bw/2 两端边，end_chamfer_y 管 Y=±D/2 两端边。
module end_chamfers() {
    if (end_chamfer_x > 0) {
        kx = bracket_width/2 - end_chamfer_x;
        half_cut_xplus(kx);
        mirror([1, 0, 0]) half_cut_xplus(kx);
    }
    if (end_chamfer_y > 0) {
        ky = D/2 - end_chamfer_y;
        half_cut_yplus(ky);
        mirror([0, 1, 0]) half_cut_yplus(ky);
    }
}

// ---- 组装 ----
// 主凸点与正高度小凸点在内部 difference 之外再 union，避免被末端倒角(end_chamfers)斜切。
// 外层 difference 仅用于 end_tip_bump_h < 0 时，从主凸点顶面中心向下打孔。
difference() {
    union() {
        difference() {
            bracket_solid();
            if (holes_on_legs) {
                leg_holes(gap/2);
                leg_holes(-gap/2 - side_wall);
            }
            if (holes_on_top)
                top_holes();
            end_chamfers();
        }
        end_bump();                    // 末端外表面中心凸点（不受倒角/钻孔影响）
        end_tip_bump();
    }
    end_tip_hole();
}

// 显示用：四舍五入到小数点后 2 位
function round2(x) = round(x * 100) / 100;

// 参考：对角四孔(45/135/225/315°)构成方形的边长 = 图中 10mm 标注
//       = 隔一孔(相距90°)的弦长 = 2·r·sin(45°)
echo(str("两侧对角孔间距(应≈10mm) = ", round2(2 * (side_bolt_circle_d/2) * sin(45)), " mm"));
echo(str("末端对角孔间距(应≈10mm) = ", round2(2 * (end_bolt_circle_d/2) * sin(45)), " mm"));
