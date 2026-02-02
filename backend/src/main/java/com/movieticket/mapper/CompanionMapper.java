package com.movieticket.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.movieticket.entity.Companion;
import org.apache.ibatis.annotations.Mapper;

/**
 * 陪伴记录 Mapper
 */
@Mapper
public interface CompanionMapper extends BaseMapper<Companion> {
}
