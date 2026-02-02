package com.movieticket.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.movieticket.common.PageResult;
import com.movieticket.common.ResultCode;
import com.movieticket.entity.Cinema;
import com.movieticket.entity.Hall;
import com.movieticket.exception.BusinessException;
import com.movieticket.mapper.CinemaMapper;
import com.movieticket.mapper.HallMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 影院服务
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CinemaService {

    private final CinemaMapper cinemaMapper;
    private final HallMapper hallMapper;

    /**
     * 分页查询影院列表
     */
    public PageResult<Cinema> getList(String city, String keyword, Integer page, Integer size) {
        Page<Cinema> pageParam = new Page<>(page, size);
        
        LambdaQueryWrapper<Cinema> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cinema::getStatus, 1); // 只查询营业中的
        
        if (StringUtils.hasText(city)) {
            wrapper.eq(Cinema::getCity, city);
        }
        
        if (StringUtils.hasText(keyword)) {
            wrapper.like(Cinema::getName, keyword);
        }
        
        wrapper.orderByDesc(Cinema::getId);
        
        Page<Cinema> result = cinemaMapper.selectPage(pageParam, wrapper);
        return PageResult.of(result);
    }

    /**
     * 获取影院详情
     */
    public Cinema getDetail(Long id) {
        Cinema cinema = cinemaMapper.selectById(id);
        if (cinema == null) {
            throw new BusinessException(ResultCode.CINEMA_NOT_EXIST);
        }
        
        // 查询关联的影厅
        List<Hall> halls = hallMapper.selectByCinemaId(id);
        cinema.setHalls(halls);
        cinema.setHallCount(halls.size());
        
        return cinema;
    }

    /**
     * 获取所有城市列表
     */
    public List<String> getCities() {
        LambdaQueryWrapper<Cinema> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cinema::getStatus, 1);
        wrapper.select(Cinema::getCity);
        wrapper.groupBy(Cinema::getCity);
        
        return cinemaMapper.selectList(wrapper)
                .stream()
                .map(Cinema::getCity)
                .distinct()
                .toList();
    }
}
