package com.movieticket.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.movieticket.entity.Movie;
import org.apache.ibatis.annotations.Mapper;

/**
 * 影片 Mapper
 */
@Mapper
public interface MovieMapper extends BaseMapper<Movie> {
}
