package com.movieticket.dto.user;

import com.movieticket.entity.User;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户视图对象 (不含敏感信息)
 */
@Data
@Schema(description = "用户信息")
public class UserVO {

    @Schema(description = "用户ID")
    private Long id;

    @Schema(description = "手机号")
    private String phone;

    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "昵称")
    private String nickname;

    @Schema(description = "头像URL")
    private String avatar;

    @Schema(description = "角色")
    private String role;

    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    /**
     * 从 User 实体转换
     */
    public static UserVO fromEntity(User user) {
        if (user == null) return null;
        
        UserVO vo = new UserVO();
        vo.setId(user.getId());
        vo.setPhone(maskPhone(user.getPhone()));
        vo.setEmail(maskEmail(user.getEmail()));
        vo.setNickname(user.getNickname());
        vo.setAvatar(user.getAvatar());
        vo.setRole(user.getRole() != null ? user.getRole().name() : null);
        vo.setCreatedAt(user.getCreatedAt());
        return vo;
    }

    /**
     * 手机号脱敏 (保留前3后4)
     */
    private static String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) return phone;
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
    }

    /**
     * 邮箱脱敏 (保留前3位@后面)
     */
    private static String maskEmail(String email) {
        if (email == null || !email.contains("@")) return email;
        int atIndex = email.indexOf("@");
        if (atIndex <= 3) return email;
        return email.substring(0, 3) + "***" + email.substring(atIndex);
    }
}
