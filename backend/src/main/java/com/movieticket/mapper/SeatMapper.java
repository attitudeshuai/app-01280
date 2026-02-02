package com.movieticket.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.movieticket.entity.Seat;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 座位 Mapper
 */
@Mapper
public interface SeatMapper extends BaseMapper<Seat> {

    /**
     * 根据场次ID查询座位列表
     */
    @Select("SELECT * FROM seat WHERE showtime_id = #{showtimeId} ORDER BY row_num, col_num")
    List<Seat> selectByShowtimeId(Long showtimeId);

    /**
     * 释放过期锁定的座位
     */
    @Update("UPDATE seat SET status = 'AVAILABLE', locked_until = NULL, locked_by = NULL " +
            "WHERE status = 'LOCKED' AND locked_until < NOW()")
    int releaseExpiredLocks();
}
