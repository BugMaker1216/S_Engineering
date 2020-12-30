package Dao;

import Po.Reserve;

import java.util.List;

public interface IReserveDAO {
    public List findByhql(String hql);
    public void save(Reserve reserve);
    public void deleteReserve(String reid);
    public List findAll(int page,int limit);
    public Long infoCount();
    public List findMyAll(int page,int limit,String uid);
    public Long infoMyCount(String uid);
}
