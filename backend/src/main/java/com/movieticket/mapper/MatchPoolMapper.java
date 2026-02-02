package com.movieticket.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.movieticket.entity.MatchPool;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 匹配池 Mapper
 */
@Mapper
public interface MatchPoolMapper extends BaseMapper<MatchPool> {

    /**
     * 查找同场次的等待匹配用户 (排除自己)
     */
    @Select("SELECT * FROM match_pool WHERE showtime_id = #{showtimeId} " +
            "AND user_id != #{userId} AND status = 'WAITING' " +
            "AND expire_time > NOW() ORDER BY created_at ASC LIMIT 1")
    MatchPool findWaitingMatch(@Param("showtimeId") Long showtimeId, @Param("userId") Long userId);

    /**
     * 清理过期的匹配池记录
     */
    @Update("UPDATE match_pool SET status = 'EXPIRED' WHERE status = 'WAITING' AND expire_time < NOW()")
    int expireOldRecords();
}
