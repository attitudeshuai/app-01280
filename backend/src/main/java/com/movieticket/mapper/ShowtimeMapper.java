package com.movieticket.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.movieticket.entity.Showtime;
import org.apache.ibatis.annotations.Mapper;

/**
 * 场次 Mapper
 */
@Mapper
public interface ShowtimeMapper extends BaseMapper<Showtime> {
}
