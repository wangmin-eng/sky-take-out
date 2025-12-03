/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50651 (5.6.51-log)
 Source Host           : localhost:3306
 Source Schema         : sky_take_out

 Target Server Type    : MySQL
 Target Server Version : 50651 (5.6.51-log)
 File Encoding         : 65001

 Date: 03/12/2025 08:57:10
*/

-- ************************ 核心补充：创建数据库 + 指定字符集 ************************
-- 若数据库已存在则先删除（可选，根据需求注释/保留）
DROP DATABASE IF EXISTS `sky_take_out`;
-- 创建数据库并指定字符集（避免导入后乱码）
CREATE DATABASE IF NOT EXISTS `sky_take_out` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
-- 切换到目标数据库（必须！否则表会创建到默认数据库）
USE `sky_take_out`;


SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address_book
-- ----------------------------
DROP TABLE IF EXISTS `address_book`;
CREATE TABLE `address_book`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `consignee` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '收货人',
  `sex` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '性别',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '手机号',
  `province_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省级区划编号',
  `province_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省级名称',
  `city_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市级区划编号',
  `city_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市级名称',
  `district_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区级区划编号',
  `district_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区级名称',
  `detail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '默认 0 否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '地址簿' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of address_book
-- ----------------------------
INSERT INTO `address_book` VALUES (1, 1, 'jackWang', '0', '13030303030', '50', '重庆市', '5001', '市辖区', '500102', '涪陵区', '长江师范学院', '3', 0);
INSERT INTO `address_book` VALUES (2, 1, 'lucy', '1', '18726377464', '11', '北京市', '1101', '市辖区', '110102', '西城区', '好地方', '1', 0);
INSERT INTO `address_book` VALUES (3, 1, 'testAddress', '0', '13848484848', '11', '北京市', '1101', '市辖区', '110106', '丰台区', 'test1', '3', 1);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` int(11) NULL DEFAULT NULL COMMENT '类型   1 菜品分类 2 套餐分类',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '分类名称',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '顺序',
  `status` int(11) NULL DEFAULT NULL COMMENT '分类状态 0:禁用，1:启用',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint(20) NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_category_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '菜品及套餐分类' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (11, 1, '酒水饮料', 10, 1, '2022-06-09 22:09:18', '2022-06-09 22:09:18', 1, 1);
INSERT INTO `category` VALUES (12, 1, '传统主食', 9, 1, '2022-06-09 22:09:32', '2022-06-09 22:18:53', 1, 1);
INSERT INTO `category` VALUES (13, 2, '人气套餐', 12, 1, '2022-06-09 22:11:38', '2022-06-10 11:04:40', 1, 1);
INSERT INTO `category` VALUES (15, 2, '商务套餐', 13, 1, '2022-06-09 22:14:10', '2022-06-10 11:04:48', 1, 1);
INSERT INTO `category` VALUES (16, 1, '蜀味烤鱼', 4, 1, '2022-06-09 22:15:37', '2022-08-31 14:27:25', 1, 1);
INSERT INTO `category` VALUES (17, 1, '蜀味牛蛙', 5, 1, '2022-06-09 22:16:14', '2022-08-31 14:39:44', 1, 1);
INSERT INTO `category` VALUES (18, 1, '特色蒸菜', 6, 1, '2022-06-09 22:17:42', '2022-06-09 22:17:42', 1, 1);
INSERT INTO `category` VALUES (19, 1, '新鲜时蔬', 7, 1, '2022-06-09 22:18:12', '2022-06-09 22:18:28', 1, 1);
INSERT INTO `category` VALUES (20, 1, '水煮鱼', 8, 1, '2022-06-09 22:22:29', '2022-06-09 22:23:45', 1, 1);
INSERT INTO `category` VALUES (21, 1, '汤类', 11, 1, '2022-06-10 10:51:47', '2022-06-10 10:51:47', 1, 1);

-- ----------------------------
-- Table structure for dish
-- ----------------------------
DROP TABLE IF EXISTS `dish`;
CREATE TABLE `dish`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '菜品名称',
  `category_id` bigint(20) NOT NULL COMMENT '菜品分类id',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '菜品价格',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '图片',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '描述信息',
  `status` int(11) NULL DEFAULT 1 COMMENT '0 停售 1 起售',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint(20) NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_dish_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '菜品' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of dish
-- ----------------------------
INSERT INTO `dish` VALUES (46, '王老吉', 11, 6.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/7baed019-5a12-49c3-9ff7-796680ac03ea.png', '', 1, '2022-06-09 22:40:47', '2025-09-02 23:59:18', 1, 1);
INSERT INTO `dish` VALUES (47, '北冰洋', 11, 4.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/b7dc445c-3a13-465f-971a-1c5807a19e79.png', '还是小时候的味道', 1, '2022-06-10 09:18:49', '2025-09-02 23:59:09', 1, 1);
INSERT INTO `dish` VALUES (48, '雪花啤酒', 11, 4.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/38b94ec1-1346-4195-b954-c9aaa061c2f3.png', '', 1, '2022-06-10 09:22:54', '2025-09-02 23:59:00', 1, 1);
INSERT INTO `dish` VALUES (49, '米饭', 12, 2.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/ea3d3742-e3ad-4450-b8c3-d4d237bf10ca.png', '精选五常大米', 1, '2022-06-10 09:30:17', '2025-09-02 23:58:51', 1, 1);
INSERT INTO `dish` VALUES (50, '馒头', 12, 1.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/80701a80-efc5-4633-b0dc-2926842f0d17.png', '优质面粉', 1, '2022-06-10 09:34:28', '2025-09-02 23:57:59', 1, 1);
INSERT INTO `dish` VALUES (51, '老坛酸菜鱼', 20, 56.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/ef47772c-6b1f-4787-9c27-5c0795b1f73b.png', '原料：汤，草鱼，酸菜', 1, '2022-06-10 09:40:51', '2025-09-02 23:58:16', 1, 1);
INSERT INTO `dish` VALUES (52, '经典酸菜鮰鱼', 20, 66.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/4bdade16-2099-49a2-aae0-292aa0a17fde.png', '原料：酸菜，江团，鮰鱼', 1, '2022-06-10 09:46:02', '2025-09-02 23:57:45', 1, 1);
INSERT INTO `dish` VALUES (53, '蜀味水煮草鱼', 20, 38.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/489cefb4-cad9-4386-a064-f20272a18bd8.png', '原料：草鱼，汤', 1, '2022-06-10 09:48:37', '2025-09-02 23:58:42', 1, 1);
INSERT INTO `dish` VALUES (54, '清炒小油菜', 19, 18.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/e8bd6853-9f40-4b99-86ad-6f50f91b0929.png', '原料：小油菜', 1, '2022-06-10 09:51:46', '2025-09-02 23:57:24', 1, 1);
INSERT INTO `dish` VALUES (55, '蒜蓉娃娃菜', 19, 18.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/f8f1d205-67e8-4fb7-acbf-8f03d34b05e4.png', '原料：蒜，娃娃菜', 1, '2022-06-10 09:53:37', '2025-09-02 23:57:15', 1, 1);
INSERT INTO `dish` VALUES (56, '清炒西兰花', 19, 18.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/eaec5fac-0e58-411a-b39a-3eaa0f00f030.png', '原料：西兰花', 1, '2022-06-10 09:55:44', '2025-09-02 23:57:03', 1, 1);
INSERT INTO `dish` VALUES (57, '炝炒圆白菜', 19, 18.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/eb8c6754-c7a3-4a95-b861-c494ec95d36c.png', '原料：圆白菜', 1, '2022-06-10 09:58:35', '2025-09-02 23:56:52', 1, 1);
INSERT INTO `dish` VALUES (58, '清蒸鲈鱼', 18, 98.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/9cace572-779c-4db1-8149-2556a3d897ce.png', '原料：鲈鱼', 1, '2022-06-10 10:12:28', '2025-09-02 23:56:42', 1, 1);
INSERT INTO `dish` VALUES (59, '东坡肘子', 18, 138.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/6072daa5-b2c1-4a4d-b3c4-e787cc11bed1.png', '原料：猪肘棒', 1, '2022-06-10 10:24:03', '2025-09-02 23:56:31', 1, 1);
INSERT INTO `dish` VALUES (60, '梅菜扣肉', 18, 58.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/63ecde4b-19ef-4842-a501-d55ce9475c8f.png', '原料：猪肉，梅菜', 1, '2022-06-10 10:26:03', '2025-09-02 23:56:11', 1, 1);
INSERT INTO `dish` VALUES (61, '剁椒鱼头', 18, 66.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/c697687d-0d91-4e70-8649-c94c15b718b8.png', '原料：鲢鱼，剁椒', 1, '2022-06-10 10:28:54', '2025-09-02 23:56:02', 1, 1);
INSERT INTO `dish` VALUES (62, '金汤酸菜牛蛙', 17, 88.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/2c863459-5fad-46f1-960b-855f81960eda.png', '原料：鲜活牛蛙，酸菜', 1, '2022-06-10 10:33:05', '2025-09-02 23:55:49', 1, 1);
INSERT INTO `dish` VALUES (63, '香锅牛蛙', 17, 88.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/25e056c5-f7db-453a-aad8-cfdcbccbe90f.png', '配料：鲜活牛蛙，莲藕，青笋', 1, '2022-06-10 10:35:40', '2025-09-02 23:55:37', 1, 1);
INSERT INTO `dish` VALUES (64, '馋嘴牛蛙', 17, 88.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/22a93113-540f-4bc7-a141-42433f950f3f.png', '配料：鲜活牛蛙，丝瓜，黄豆芽', 1, '2022-06-10 10:37:52', '2025-09-02 23:55:17', 1, 1);
INSERT INTO `dish` VALUES (65, '草鱼2斤', 16, 68.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/fcd5df96-2220-47a3-9051-9f1724099797.png', '原料：草鱼，黄豆芽，莲藕', 1, '2022-06-10 10:41:08', '2025-09-02 23:54:59', 1, 1);
INSERT INTO `dish` VALUES (66, '江团鱼2斤', 16, 119.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/46e0bb7f-6b8f-4576-b651-f80227ac8b55.png', '配料：江团鱼，黄豆芽，莲藕', 1, '2022-06-10 10:42:42', '2025-09-02 23:54:33', 1, 1);
INSERT INTO `dish` VALUES (67, '鮰鱼2斤', 16, 99.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/bf57ef1e-97e3-4a7d-9342-46a201362793.png', '原料：鮰鱼，黄豆芽，莲藕', 1, '2022-06-10 10:43:56', '2025-09-03 21:57:50', 1, 1);
INSERT INTO `dish` VALUES (68, '鸡蛋汤', 21, 4.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/c0e797d0-13b7-425d-9817-eb049664955b.png', '配料：鸡蛋，紫菜', 1, '2022-06-10 10:54:25', '2025-09-02 23:53:45', 1, 1);
INSERT INTO `dish` VALUES (69, '平菇豆腐汤', 21, 6.00, 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/34f572cb-181c-42f3-bb88-45dff36d93fc.png', '配料：豆腐，平菇', 1, '2022-06-10 10:55:02', '2025-09-03 21:55:30', 1, 1);

-- ----------------------------
-- Table structure for dish_flavor
-- ----------------------------
DROP TABLE IF EXISTS `dish_flavor`;
CREATE TABLE `dish_flavor`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dish_id` bigint(20) NOT NULL COMMENT '菜品',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '口味名称',
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '口味数据list',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 118 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '菜品口味关系表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of dish_flavor
-- ----------------------------
INSERT INTO `dish_flavor` VALUES (40, 10, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (41, 7, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (42, 7, '温度', '[\"热饮\",\"常温\",\"去冰\",\"少冰\",\"多冰\"]');
INSERT INTO `dish_flavor` VALUES (45, 6, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (46, 6, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (47, 5, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (48, 5, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (49, 2, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (50, 4, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (51, 3, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (52, 3, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (105, 66, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (106, 65, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (107, 60, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (108, 57, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (109, 56, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (110, 54, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\"]');
INSERT INTO `dish_flavor` VALUES (111, 52, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (112, 52, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (113, 51, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (114, 51, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (115, 53, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (116, 53, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (117, 67, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '姓名',
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '密码',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '手机号',
  `sex` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '性别',
  `id_number` varchar(18) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '身份证号',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态 0:禁用，1:启用',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint(20) NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '员工信息' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES (1, '管理员', 'admin', 'e10adc3949ba59abbe56e057f20f883e', '13812312312', '1', '110101199001010047', 1, '2022-02-15 15:51:20', '2022-02-17 09:16:20', 10, 1);
INSERT INTO `employee` VALUES (2, 'king', 'king', 'e10adc3949ba59abbe56e057f20f883e', '13013013011', '1', '114514', 1, '2025-07-29 17:10:39', '2025-07-29 17:10:39', 10, 10);
INSERT INTO `employee` VALUES (3, '李四', 'lisi', 'e10adc3949ba59abbe56e057f20f883e', '13232323232', '1', '111222333444555666', 1, '2025-07-29 17:14:15', '2025-07-29 17:14:15', 10, 10);
INSERT INTO `employee` VALUES (4, '王五六', 'wangwuliu', 'e10adc3949ba59abbe56e057f20f883e', '13756489372', '0', '555555555555554', 1, '2025-08-09 21:09:04', '2025-08-24 22:18:10', 1, 1);

-- ----------------------------
-- Table structure for order_detail
-- ----------------------------
DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '名字',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '图片',
  `order_id` bigint(20) NOT NULL COMMENT '订单id',
  `dish_id` bigint(20) NULL DEFAULT NULL COMMENT '菜品id',
  `setmeal_id` bigint(20) NULL DEFAULT NULL COMMENT '套餐id',
  `dish_flavor` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '口味',
  `number` int(11) NOT NULL DEFAULT 1 COMMENT '数量',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '订单明细表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of order_detail
-- ----------------------------
INSERT INTO `order_detail` VALUES (1, '鮰鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/bf57ef1e-97e3-4a7d-9342-46a201362793.png', 1, 67, NULL, '不辣', 1, 99.00);
INSERT INTO `order_detail` VALUES (2, '鮰鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/bf57ef1e-97e3-4a7d-9342-46a201362793.png', 1, 67, NULL, '微辣', 1, 99.00);
INSERT INTO `order_detail` VALUES (3, '江团鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/46e0bb7f-6b8f-4576-b651-f80227ac8b55.png', 1, 66, NULL, '不辣', 1, 119.00);
INSERT INTO `order_detail` VALUES (4, '雪花啤酒', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/38b94ec1-1346-4195-b954-c9aaa061c2f3.png', 1, 48, NULL, NULL, 1, 4.00);
INSERT INTO `order_detail` VALUES (5, '鮰鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/bf57ef1e-97e3-4a7d-9342-46a201362793.png', 2, 67, NULL, '不辣', 1, 99.00);
INSERT INTO `order_detail` VALUES (6, '江团鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/46e0bb7f-6b8f-4576-b651-f80227ac8b55.png', 2, 66, NULL, '微辣', 1, 119.00);
INSERT INTO `order_detail` VALUES (7, '草鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/fcd5df96-2220-47a3-9051-9f1724099797.png', 2, 65, NULL, '中辣', 1, 68.00);
INSERT INTO `order_detail` VALUES (8, '鮰鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/bf57ef1e-97e3-4a7d-9342-46a201362793.png', 3, 67, NULL, '不辣', 1, 99.00);
INSERT INTO `order_detail` VALUES (9, '草鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/fcd5df96-2220-47a3-9051-9f1724099797.png', 4, 65, NULL, '不辣', 1, 68.00);
INSERT INTO `order_detail` VALUES (10, '馋嘴牛蛙', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/22a93113-540f-4bc7-a141-42433f950f3f.png', 5, 64, NULL, NULL, 1, 88.00);
INSERT INTO `order_detail` VALUES (11, '馒头', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/80701a80-efc5-4633-b0dc-2926842f0d17.png', 6, 50, NULL, NULL, 1, 1.00);
INSERT INTO `order_detail` VALUES (12, '馒头', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/80701a80-efc5-4633-b0dc-2926842f0d17.png', 7, 50, NULL, NULL, 1, 1.00);
INSERT INTO `order_detail` VALUES (13, '鮰鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/bf57ef1e-97e3-4a7d-9342-46a201362793.png', 8, 67, NULL, '不辣', 1, 99.00);
INSERT INTO `order_detail` VALUES (14, '鮰鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/bf57ef1e-97e3-4a7d-9342-46a201362793.png', 9, 67, NULL, '不辣', 1, 99.00);
INSERT INTO `order_detail` VALUES (15, '鮰鱼2斤', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/bf57ef1e-97e3-4a7d-9342-46a201362793.png', 10, 67, NULL, '不辣', 1, 99.00);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `number` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '订单号',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '订单状态 1待付款 2待接单 3已接单 4派送中 5已完成 6已取消 7退款',
  `user_id` bigint(20) NOT NULL COMMENT '下单用户',
  `address_book_id` bigint(20) NOT NULL COMMENT '地址id',
  `order_time` datetime NOT NULL COMMENT '下单时间',
  `checkout_time` datetime NULL DEFAULT NULL COMMENT '结账时间',
  `pay_method` int(11) NOT NULL DEFAULT 1 COMMENT '支付方式 1微信,2支付宝',
  `pay_status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '支付状态 0未支付 1已支付 2退款',
  `amount` decimal(10, 2) NOT NULL COMMENT '实收金额',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '备注',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '手机号',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '地址',
  `user_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '用户名称',
  `consignee` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '收货人',
  `cancel_reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '订单取消原因',
  `rejection_reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '订单拒绝原因',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '订单取消时间',
  `estimated_delivery_time` datetime NULL DEFAULT NULL COMMENT '预计送达时间',
  `delivery_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '配送状态  1立即送出  0选择具体时间',
  `delivery_time` datetime NULL DEFAULT NULL COMMENT '送达时间',
  `pack_amount` int(11) NULL DEFAULT NULL COMMENT '打包费',
  `tableware_number` int(11) NULL DEFAULT NULL COMMENT '餐具数量',
  `tableware_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '餐具数量状态  1按餐量提供  0选择具体数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '订单表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, '1757333725756', 6, 1, 2, '2025-09-08 20:15:26', NULL, 1, 0, 331.00, '', '18726377464', NULL, NULL, 'lucy', '订单量较多，暂时无法接单', NULL, '2025-09-12 22:00:23', '2025-09-08 21:15:00', 0, NULL, 4, 0, 0);
INSERT INTO `orders` VALUES (2, '1757664265097', 5, 1, 1, '2025-09-12 16:04:25', NULL, 1, 1, 295.00, '', '13030303030', NULL, NULL, 'jackWang', NULL, NULL, NULL, '2025-09-12 17:04:00', 0, NULL, 3, 0, 0);
INSERT INTO `orders` VALUES (3, '1757666928663', 6, 1, 3, '2025-09-12 16:48:49', NULL, 1, 0, 106.00, '', '13848484848', 'test', NULL, 'testAddress', '订单超时自动取消', NULL, '2025-09-13 20:38:00', '2025-09-12 17:48:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (4, '1757667318260', 6, 1, 3, '2025-09-12 16:55:18', NULL, 1, 0, 75.00, '', '13848484848', '北京市市辖区丰台区', NULL, 'testAddress', '订单超时自动取消', NULL, '2025-09-13 20:38:00', '2025-09-12 17:55:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (5, '1757667446824', 6, 1, 3, '2025-09-12 16:57:27', NULL, 1, 0, 95.00, '', '13848484848', '北京市市辖区丰台区test1', NULL, 'testAddress', '订单超时自动取消', NULL, '2025-09-13 20:38:00', '2025-09-12 17:57:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (6, '1757676209758', 6, 1, 3, '2025-09-12 19:23:30', '2025-09-12 19:23:44', 1, 0, 8.00, '', '13848484848', '北京市市辖区丰台区test1', NULL, 'testAddress', '用户取消订单', NULL, NULL, '2025-09-12 20:23:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (7, '1757683033957', 5, 1, 3, '2025-09-12 21:17:14', NULL, 1, 1, 8.00, '', '13848484848', '北京市市辖区丰台区test1', NULL, 'testAddress', NULL, NULL, NULL, '2025-09-12 22:17:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (8, '1757684577246', 6, 1, 3, '2025-09-12 21:42:57', NULL, 1, 1, 106.00, '', '13848484848', '北京市市辖区丰台区test1', NULL, 'testAddress', NULL, '订单量较多，暂时无法接单', '2025-09-12 21:43:55', '2025-09-12 22:42:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (9, '1757954846149', 6, 1, 3, '2025-09-16 00:47:26', NULL, 1, 0, 106.00, '', '13848484848', '北京市市辖区丰台区test1', NULL, 'testAddress', '订单超时自动取消', NULL, '2025-09-16 01:05:00', '2025-09-16 01:47:00', 0, NULL, 1, 1, 0);
INSERT INTO `orders` VALUES (10, '1757955891313', 5, 1, 3, '2025-09-16 01:04:51', NULL, 1, 1, 106.00, '', '13848484848', '北京市市辖区丰台区test1', NULL, 'testAddress', NULL, NULL, NULL, '2025-09-16 02:04:00', 0, '2025-09-17 15:45:26', 1, 0, 0);

-- ----------------------------
-- Table structure for setmeal
-- ----------------------------
DROP TABLE IF EXISTS `setmeal`;
CREATE TABLE `setmeal`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `category_id` bigint(20) NOT NULL COMMENT '菜品分类id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '套餐名称',
  `price` decimal(10, 2) NOT NULL COMMENT '套餐价格',
  `status` int(11) NULL DEFAULT 1 COMMENT '售卖状态 0:停售 1:起售',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '描述信息',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '图片',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint(20) NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_setmeal_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '套餐' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of setmeal
-- ----------------------------
INSERT INTO `setmeal` VALUES (1, 13, '迎宾test', 11.00, 1, '啊啊啊啊x1', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/1fe01c98-b0cc-4c0e-bb3b-657109649880.png', '2025-09-02 20:30:29', '2025-09-02 23:19:34', 1, 1);
INSERT INTO `setmeal` VALUES (4, 15, 'good', 22.00, 0, '222', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/4f9078de-ae1a-46b2-9d44-4eaaff0001ec.png', '2025-09-06 23:56:39', '2025-09-07 00:06:44', 1, 1);
INSERT INTO `setmeal` VALUES (6, 15, 'test', 22.00, 1, '222', 'https://webfortest.oss-cn-hangzhou.aliyuncs.com/4f9078de-ae1a-46b2-9d44-4eaaff0001ec.png', '2025-09-06 23:59:01', '2025-09-07 00:03:37', 1, 1);

-- ----------------------------
-- Table structure for setmeal_dish
-- ----------------------------
DROP TABLE IF EXISTS `setmeal_dish`;
CREATE TABLE `setmeal_dish`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `setmeal_id` bigint(20) NULL DEFAULT NULL COMMENT '套餐id',
  `dish_id` bigint(20) NULL DEFAULT NULL COMMENT '菜品id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '菜品名称 （冗余字段）',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '菜品单价（冗余字段）',
  `copies` int(11) NULL DEFAULT NULL COMMENT '菜品份数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '套餐菜品关系' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of setmeal_dish
-- ----------------------------
INSERT INTO `setmeal_dish` VALUES (7, 1, 65, '草鱼2斤', 68.00, 1);
INSERT INTO `setmeal_dish` VALUES (8, 1, 66, '江团鱼2斤', 119.00, 1);
INSERT INTO `setmeal_dish` VALUES (9, 4, 57, '炝炒圆白菜', 18.00, 1);
INSERT INTO `setmeal_dish` VALUES (10, 4, 69, '平菇豆腐汤', 6.00, 1);
INSERT INTO `setmeal_dish` VALUES (11, 6, 57, '炝炒圆白菜', 18.00, 1);
INSERT INTO `setmeal_dish` VALUES (12, 6, 69, '平菇豆腐汤', 6.00, 1);

-- ----------------------------
-- Table structure for shopping_cart
-- ----------------------------
DROP TABLE IF EXISTS `shopping_cart`;
CREATE TABLE `shopping_cart`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '商品名称',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '图片',
  `user_id` bigint(20) NOT NULL COMMENT '主键',
  `dish_id` bigint(20) NULL DEFAULT NULL COMMENT '菜品id',
  `setmeal_id` bigint(20) NULL DEFAULT NULL COMMENT '套餐id',
  `dish_flavor` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '口味',
  `number` int(11) NOT NULL DEFAULT 1 COMMENT '数量',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '购物车' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of shopping_cart
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `openid` varchar(45) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '微信用户唯一标识',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '姓名',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '手机号',
  `sex` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '性别',
  `id_number` varchar(18) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '身份证号',
  `avatar` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '头像',
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '用户信息' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'ohMN61zNs0WSigGr2Y1mN2QWaLVM', NULL, NULL, NULL, NULL, NULL, '2025-09-01 23:42:03');

SET FOREIGN_KEY_CHECKS = 1;
