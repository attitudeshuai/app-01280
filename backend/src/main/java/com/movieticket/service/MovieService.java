package com.movieticket.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.movieticket.common.PageResult;
import com.movieticket.common.ResultCode;
import com.movieticket.entity.Movie;
import com.movieticket.exception.BusinessException;
import com.movieticket.mapper.MovieMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

/**
 * 影片服务
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MovieService {

    private final MovieMapper movieMapper;

    /**
     * 分页查询影片列表
     */
    public PageResult<Movie> getList(String status, String keyword, Integer page, Integer size) {
        Page<Movie> pageParam = new Page<>(page, size);
        
        LambdaQueryWrapper<Movie> wrapper = new LambdaQueryWrapper<>();
        
        // 按状态筛选
        if (StringUtils.hasText(status)) {
            wrapper.eq(Movie::getStatus, Movie.StatusEnum.valueOf(status));
        } else {
            // 默认不显示已下架的
            wrapper.ne(Movie::getStatus, Movie.StatusEnum.OFFLINE);
        }
        
        // 关键词搜索
        if (StringUtils.hasText(keyword)) {
            wrapper.like(Movie::getTitle, keyword);
        }
        
        // 排序: 评分高的优先
        wrapper.orderByDesc(Movie::getRating);
        
        Page<Movie> result = movieMapper.selectPage(pageParam, wrapper);
        return PageResult.of(result);
    }

    /**
     * 获取热映影片 (缓存10分钟)
     */
    @Cacheable(value = "movies", key = "'showing:' + #page + ':' + #size")
    public PageResult<Movie> getShowing(Integer page, Integer size) {
        return getList("SHOWING", null, page, size);
    }

    /**
     * 获取即将上映影片 (缓存10分钟)
     */
    @Cacheable(value = "movies", key = "'coming:' + #page + ':' + #size")
    public PageResult<Movie> getComing(Integer page, Integer size) {
        return getList("COMING", null, page, size);
    }

    /**
     * 获取影片详情 (缓存10分钟)
     */
    @Cacheable(value = "movies", key = "'detail:' + #id")
    public Movie getDetail(Long id) {
        Movie movie = movieMapper.selectById(id);
        if (movie == null) {
            throw new BusinessException(ResultCode.MOVIE_NOT_EXIST);
        }
        return movie;
    }
}
