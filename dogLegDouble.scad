// 双U狗腿支架 (Dogleg Double-U Bracket) —— 在主U支架的凸点末端再生成一个相同的U型结构
//
//        ┌───────────┐        <- 第二个 U 的圆头 + 孔组（腿朝 +Z）
//        │ ·  (O)  · │
//         \         /
//          \_______/         <- 第二个 U 的顶板
//             │▓│            <- 连接凸点(boss)：主U凸点末端 ←→ 第二个U顶板
//          ┌──┴─┴──┐         <- 主 U 的顶板 (Z=0 外表面)
//         /         \
//        │ ·  (O)  · │
//        │           │       <- 主 U 的两侧(legs)，腿朝 -Z
//        │ ·  (O)  · │
//        └───────────┘
//
// 本文件参照 dogLeg.scad（直U支架）编写：保留其全部参数与模块，
// 将单个支架封装为模块 u_bracket()，并在“主凸点末端(凸点顶端)”再叠加一个相同的 U 型结构，
// 形成 dogleg（两段U）。第二个 U 经 rotate([180,0,0]) 翻转，腿朝 +Z，与主体背靠背，
// 由中央凸点(boss)连接；主U的顶部小凸点(end_tip_bump)恰好探入第二个U的中心孔，充当对焦销。
//
// 【侧壁】两个 U 各有两条侧壁(腿)，共 4 条，厚度均可独立配置；某条设为 0 即“该侧壁不存在”
//        （连同其腿面孔、内倒角一并省略），顶板在该侧收到内侧间距(gap)边界，形成单壁/无壁形态。
//
// 单位：mm。所有尺寸均为浮点，支持小数点后两位（如 3.25）；Customizer 中以 0.01 步进。

/* [侧壁厚度 —— 4 条U型侧壁独立配置；0 = 该侧壁不存在] */
// 主U +Y 侧壁厚 (mm)；0=无此壁
main_wall_right   = 3.00;  // [0:0.01:20]
// 主U −Y 侧壁厚 (mm)；0=无此壁
main_wall_left    = 3.00;  // [0:0.01:20]
// 第二U +Y(本体局部) 侧壁厚 (mm)；0=无此壁（经翻转后该壁位于世界 −Y 侧）
second_wall_right = 3.00;  // [0:0.01:20]
// 第二U −Y(本体局部) 侧壁厚 (mm)；0=无此壁（经翻转后该壁位于世界 +Y 侧）
second_wall_left  = 3.00;  // [0:0.01:20]

/* [顶板厚度] */
// 末端(顶板)壁厚 (mm)，两个 U 通用
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
// Y 向倒角：深度两端边(沿 X)的 45° 倒角尺寸（0=关闭） (mm)
end_chamfer_y = 3.00;  // [0:0.01:20]

/* [内侧倒角] */
// U 型内侧两条边（两侧壁内表面与底面相交处）的 45° 加强倒角尺寸（0=关闭） (mm)
inner_chamfer = 2.00;  // [0:0.01:20]

/* [末端凸点] —— 顶板外表面(Z=0)中心单个凸起，圆形或矩形（此凸点即两段U的连接boss） */
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
// 在主末端凸点的顶部端面中心再添加一个较小凸点（开启第二个U时充当对焦销）。
end_tip_bump_on = true;
end_tip_bump_shape = 0;      // [0:圆形, 1:矩形]
// 高度为正数时生成凸点；为负数时从主凸点顶部向下打孔，孔深=绝对值。
end_tip_bump_h = 1.00;       // [-300:0.01:300]
end_tip_bump_d = 5.00;       // [0.1:0.01:300]
end_tip_bump_x = 5.00;       // [0.1:0.01:300]
end_tip_bump_y = 5.00;       // [0.1:0.01:300]
end_tip_bump_chamfer = 0.50; // [0:0.01:150]
end_tip_bump_root = 0.50;    // [0:0.01:150]

/* [凸点末端的第二个 U —— dogleg 第二段] */
// 总开关：在主凸点末端再生成一个相同的 U 型结构
second_u_on = true;
// 第二个 U 绕 Z 轴的旋转角（0=与主体朝向一致；常用 90/180 等） (度)
second_u_rotate = 0.00;   // [0:0.01:360]
// 第二个 U 与主凸点末端的搭接量（向下沉入主凸点，保证实体连通、可打印） (mm)
second_u_join = 0.50;     // [0:0.01:5]
// 第二个 U 是否也带自己的末端凸点（默认否，避免与主连接凸点冲突）
second_u_bump = false;

/* [渲染精度] */
$fn = 64;
eps = 0.05;

// ---- 派生量 ----
r_round = bracket_width / 2;            // 圆头半径
zc_leg  = -(leg_length - r_round);      // 腿上孔组中心 Z（即圆头圆心）

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
// 单条腿：直段(方块) + 圆头(沿 Y 的圆柱)，腿厚 = w 沿 Y。w=0 时不生成（该侧壁不存在）。
// ys = 腿在 Y 方向的起始(最小)坐标。
module leg(ys, w) {
    if (w > 0) {
        // 直段：自顶板(Z=0)向下到圆心 zc_leg
        translate([-bracket_width/2, ys, zc_leg])
            cube([bracket_width, w, leg_length - r_round]);
        // 圆头：轴沿 +Y 的圆柱
        translate([0, ys, zc_leg])
            rotate([-90, 0, 0])
                cylinder(h = w, r = r_round);
    }
}

// 顶板：Y 向跨度随两条侧壁厚度而变（非对称）。内侧间距固定居中于原点(Y=0)；
// +Y 边到 gap/2+wr，−Y 边到 −(gap/2+wl)。侧壁为 0 时该边收到内侧间距处(±gap/2)。
module top_plate(wr, wl) {
    y_min = -(gap/2 + wl);
    d     = gap + wr + wl;
    translate([-bracket_width/2, y_min, -end_wall])
        cube([bracket_width, d, end_wall]);
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
// 仅在对应侧壁存在(w>0)时才加该侧内倒角。
module inner_chamfers(wr, wl) {
    if (inner_chamfer > 0) {
        if (wr > 0) inner_chamfer_one();                    // +Y 内侧
        if (wl > 0) mirror([0, 1, 0]) inner_chamfer_one();  // −Y 内侧
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

// 单个支架实体：顶板 + 两条侧壁(各自厚度 wr/wl，0 则缺失) + 存在侧的内倒角。
module bracket_solid(wr, wl) {
    union() {
        top_plate(wr, wl);
        leg(gap/2, wr);              // +Y 腿（右）
        leg(-gap/2 - wl, wl);        // −Y 腿（左）
        inner_chamfers(wr, wl);
    }
}

// ---- 钻孔 ----
// 腿面孔：孔组在 X-Z 面，沿 Y 钻穿。ys = 腿面起始 Y，w = 腿厚（0 则不钻）。
module leg_holes(ys, w) {
    if (w > 0)
        translate([0, ys - eps, zc_leg])
            rotate([-90, 0, 0])
                linear_extrude(height = w + 2 * eps)
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
// 顶板外平面(z=0)四条边切 45° 楔形。X 向两端边由 end_chamfer_x 管；
// Y 向两端边按各自侧壁外缘(±(gap/2+w))定位，故 +Y/−Y 可因侧壁厚度不同而非对称。
module end_chamfers(wr, wl) {
    if (end_chamfer_x > 0) {
        kx = bracket_width/2 - end_chamfer_x;
        half_cut_xplus(kx);
        mirror([1, 0, 0]) half_cut_xplus(kx);
    }
    if (end_chamfer_y > 0) {
        half_cut_yplus((gap/2 + wr) - end_chamfer_y);                    // +Y 边
        mirror([0, 1, 0]) half_cut_yplus((gap/2 + wl) - end_chamfer_y);  // −Y 边
    }
}

// ---- 单个 U 支架（封装为模块，便于复用/堆叠） ----
// wr/wl：+Y / −Y 侧壁厚度（0=该侧壁不存在）。
// include_bump：是否生成末端连接凸点(boss)及顶部小凸点/打孔。
// 主凸点与正高度小凸点在内部 difference 之外再 union，避免被末端倒角(end_chamfers)斜切。
// 外层 difference 仅用于 end_tip_bump_h < 0 时，从主凸点顶面中心向下打孔。
module u_bracket(wr, wl, include_bump = true) {
    difference() {
        union() {
            difference() {
                bracket_solid(wr, wl);
                if (holes_on_legs) {
                    leg_holes(gap/2, wr);
                    leg_holes(-gap/2 - wl, wl);
                }
                if (holes_on_top)
                    top_holes();
                end_chamfers(wr, wl);
            }
            if (include_bump) {
                end_bump();        // 末端外表面中心凸点（不受倒角/钻孔影响）
                end_tip_bump();
            }
        }
        if (include_bump)
            end_tip_hole();
    }
}

// ---- 连接面 Z：主凸点末端(顶端)的 Z 坐标 = 直壁高度 + 顶倒角 ----
// 与 end_bump() 内 clamp 一致；无凸点时退化为顶板外表面 Z=0。
parent_inr_main = (end_bump_shape == 0) ? end_bump_d/2
                                        : min(end_bump_x, end_bump_y)/2;
parent_c_main   = min(max(end_bump_chamfer, 0), max(0, parent_inr_main - eps));
bump_top_z      = (end_bump_on && end_bump_h > 0) ? end_bump_h + parent_c_main : 0;

// ---- 组装：主体 U + 凸点末端的第二个 U（dogleg） ----
u_bracket(main_wall_right, main_wall_left, include_bump = true);   // 主 U（含连接凸点/对焦销）

if (second_u_on)
    // 下沉 second_u_join 与主凸点搭接 → 保证两段实体连通；
    // rotate([180,0,0]) 翻转使第二个 U 的腿朝 +Z，与主体背靠背；
    // rotate([0,0,a]) 可绕轴线旋转第二段朝向。
    translate([0, 0, bump_top_z - second_u_join])
        rotate([0, 0, second_u_rotate])
            rotate([180, 0, 0])
                u_bracket(second_wall_right, second_wall_left, include_bump = second_u_bump);

// 显示用：四舍五入到小数点后 2 位
function round2(x) = round(x * 100) / 100;

// 参考：对角四孔(45/135/225/315°)构成方形的边长 = 图中 10mm 标注
//       = 隔一孔(相距90°)的弦长 = 2·r·sin(45°)
echo(str("两侧对角孔间距(应≈10mm) = ", round2(2 * (side_bolt_circle_d/2) * sin(45)), " mm"));
echo(str("末端对角孔间距(应≈10mm) = ", round2(2 * (end_bolt_circle_d/2) * sin(45)), " mm"));
echo(str("连接面(主凸点末端) Z = ", round2(bump_top_z), " mm"));
echo(str("主U顶板Y跨度 = [", round2(-(gap/2 + main_wall_left)), ", ",
         round2(gap/2 + main_wall_right), "] mm"));
echo(str("总高(主腿底 → 第二U腿顶) ≈ ",
         round2(leg_length + (bump_top_z - second_u_join) + leg_length), " mm"));
