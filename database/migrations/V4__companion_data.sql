-- =============================================
-- Phase 2: 陪伴功能测试数据
-- =============================================

SET NAMES utf8mb4;

-- 玩偶类型数据 (8种可爱玩偶)
INSERT INTO `doll_type` (`name`, `description`, `image_url`, `price`, `stock`, `sort_order`, `status`) VALUES
('皮卡丘', '超萌皮卡丘玩偶，电影院人气王！黄色毛绒触感，陪你一起享受电影时光~', 'https://images.unsplash.com/photo-1605979257913-1704eb7b6246?w=300&h=300&fit=crop', 15.00, 50, 1, 1),
('经典泰迪熊', '经典棕色泰迪熊，柔软温暖，给你最温馨的陪伴。适合所有年龄段的观影伙伴！', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop', 12.00, 80, 2, 1),
('哆啦A梦', '来自未来的蓝胖子，口袋里装满惊喜！经典日漫IP，童年回忆杀~', 'https://images.unsplash.com/photo-1608889476561-6242cfdbf622?w=300&h=300&fit=crop', 18.00, 40, 3, 1),
('草莓熊Lotso', '粉色草莓熊，散发淡淡草莓香，超级治愈系！拥抱它感受满满幸福感~', 'https://images.unsplash.com/photo-1559715745-e1b33a271c8f?w=300&h=300&fit=crop', 20.00, 30, 4, 1),
('宫崎骏龙猫', '宫崎骏经典龙猫Totoro，毛茸茸超级可爱，仿佛置身于龙猫森林~', 'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=300&h=300&fit=crop', 22.00, 25, 5, 1),
('史迪奇Stitch', '蓝色小怪兽史迪奇，调皮又可爱！迪士尼人气IP，陪伴你的观影时光~', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop', 16.00, 45, 6, 1),
('三丽鸥惊喜盒', '包含Hello Kitty/美乐蒂/库洛米/大耳狗随机一只！三丽鸥粉丝必选~', 'https://images.unsplash.com/photo-1563901935883-cb2f98f35577?w=300&h=300&fit=crop', 25.00, 20, 7, 1),
('小黄人Bob', 'Banana！萌萌小黄人陪你欢乐观影，保证让你笑声不断~', 'https://images.unsplash.com/photo-1608889825205-eebdb9fc5806?w=300&h=300&fit=crop', 14.00, 60, 8, 1);
