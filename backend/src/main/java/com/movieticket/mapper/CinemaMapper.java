package com.movieticket.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.movieticket.entity.Cinema;
import org.apache.ibatis.annotations.Mapper;

/**
 * 影院 Mapper
 */
@Mapper
public interface CinemaMapper extends BaseMapper<Cinema> {
}
