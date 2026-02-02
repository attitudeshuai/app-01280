package com.movieticket.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.movieticket.entity.Hall;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 影厅 Mapper
 */
@Mapper
public interface HallMapper extends BaseMapper<Hall> {

    /**
     * 根据影院ID查询影厅列表
     */
    @Select("SELECT * FROM hall WHERE cinema_id = #{cinemaId} AND status = 1 ORDER BY id")
    List<Hall> selectByCinemaId(Long cinemaId);
}
