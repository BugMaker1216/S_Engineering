<%--
  Created by IntelliJ IDEA.
  User: Chital
  Date: 2020/12/15
  Time: 15:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>员工信息</title>
    <link rel="stylesheet" href="layui/css/layui.css"  media="all">
    <script src="layui/layui.js" charset="utf-8"></script>
</head>
<body>

<!--用户表格-->
<table class="layui-hide" id="TTTtest" lay-filter="test"></table>

<!--弹出层-->
<div class="site-text" style="margin: 5%; display: none" id="box1"  target="123">
    <form class="layui-form layui-form-pane" onsubmit="return false" id="booktype">
        <div class="layui-form-item">
            <label class="layui-form-label"> 姓名</label>
            <div class="layui-input-block">
                <input type="text" class="layui-input"  id="uname"  name=cid ><br>
            </div>
            <br>
            <label class="layui-form-label"> 密码</label>
            <div class="layui-input-block">
                <input type="text" class="layui-input"  id="upassword"  name=cname><br>
            </div>

            <label class="layui-form-label"> 身份</label>
            <div class="layui-input-block">
                <input type="text" class="layui-input"  id="uidentity"  name="cteacher"><br>
            </div>

        </div>
    </form>
</div>


<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="getCheckData">获取选中行数据</button>
        <button class="layui-btn layui-btn-sm" lay-event="getCheckLength">获取选中数目</button>
        <button class="layui-btn layui-btn-sm" lay-event="isAll">验证是否全选</button>
    </div>
</script>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<script type="text/javascript" src="layui/lay/modules/jquery.js"></script>

<!--问题：找不到及时显示刷新后数据的方法-->
<!--显示图片的templet-->
<script type="text/html" id="imgTpl">
    <img src="{{d.upicture}}">
</script>

<script>
    //定义全局变量$
    var $=layui.jquery;

    //照片弹出框的展示
    function show_img(t) {
        var t = $(t).find("img");
        //页面层
        layer.open({
            type: 1,
            skin: 'layui-layer-rim', //加上边框
            area: ['60%', '80%'], //宽高
            shadeClose: true, //开启遮罩关闭
            end: function (index, layero) {
                return false;
            },
            content: '<div style="text-align:center"><img src="' + $(t).attr('src') + '" /></div>'
        });
    }

    layui.use(['jquery','table'], function(){
        var load = layui.layer.load(0);// 加载时loading效果
        layui.layer.close(load); //加载效果

        var table = layui.table;

        //表格的渲染
        table.render({
            //指向的是表格的id
            elem: '#TTTtest'
            ,url:'zpjsonUserList.action'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'LAYTABLE_TIPS'
                ,icon: 'layui-icon-tips'
            }]
            ,title:'职员数据表'
            ,cols: [[
                {type: 'checkbox', fixed: 'left'}
                ,{field:'uid', title:'编号', sort: true}
                ,{field:'uname', title:'姓名', sort: true}
                ,{field:'upassword', title:'密码', sort: true}
                ,{field:'uidentity', title:'身份', sort: true}
                ,{
                field:'upicture'
                    , title:'照片'
                    //定义照片的展示模板
                    ,templet:function(d){
                        return '<div onclick="show_img(this)" ><img src="'+d.upicture+'" width="30px" height="30px"></a></div>';
                    }
                }
                ,{fixed: 'right', title:'操作', toolbar: '#barDemo',fixed: 'right'}
            ]]
            ,page: true
        });

        //头工具栏事件
        table.on('toolbar(test)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            switch(obj.event){
                case 'getCheckData':
                    var data = checkStatus.data;
                    layer.alert(JSON.stringify(data));
                    break;
                case 'getCheckLength':
                    var data = checkStatus.data;
                    layer.msg('选中了：'+ data.length + ' 个');
                    break;
                case 'isAll':
                    layer.msg(checkStatus.isAll ? '全选': '未全选');
                    break;
                //自定义头工具栏右侧图标 - 提示
                case 'LAYTABLE_TIPS':
                    layer.alert('这是工具栏右侧自定义的一个图标按钮');
                    break;
            };
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){
            var data = obj.data; //获得当前行数据
            var urlex="${pageContext.request.contextPath}";
            var tr=obj.tr//活动当前行tr 的  DOM对象
            console.log(data);
            if(obj.event === 'del'){
                /*layer.confirm('真的删除行么', function (index) {
                    obj.del();
                    layer.close(index);
                });*/
                layer.confirm('确定删除吗？',{title:'删除'}, function(index){
                    //向服务端发送删除指令og
                    $.getJSON('delete.action',{uid:$('#reid').val()}, function(ret){
                    });
                    layer.close(index);//关闭弹窗
                    table.reload('TTTtest',{page:{curr:1}});
                });

            } else if(obj.event === 'edit'){
                //这里是编辑
                layer.open({
                    type: 1 //Page层类型
                    ,skin: 'layui-layer-molv'
                    ,area: ['380px', '270px']
                    ,title: ['编辑用户信息','font-size:18px']
                    ,btn: ['确定', '取消']
                    ,shadeClose: true
                    ,shade: 0 //遮罩透明度
                    ,maxmin: true //允许全屏最小化
                    ,content:$('#box1')  //弹窗id
                    ,success:function(layero,index){
                        $('#uname').val(data.uname);
                        $('#upassword').val(data.upassword);
                        $('#uidentity').val(data.uidentity);
                    },yes:function(index,layero){
                        $.getJSON('update.action',{
                            uname: $('#uname').val(),
                            upassword: $('#upassword').val(),
                            uidentity:$('#uidentity').val(),
                            uid: data.uid,
                        });
                        layer.close(index);//关闭弹窗
                        table.reload('TTTtest',{page:{curr:1}});
                    }
                });
            }
        });
    });
</script>
</body>
</html>
