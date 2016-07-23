# 根据scrollview的滑动，改变导航栏透明度
```Objective-C
func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y + self.tableView.contentInset.top
        if contentOffsetY < 0 {
            self.navigationController?.navigationBar.subviews[0].alpha = 0
            var headerViewHeight = tableHeaderViewDefaultHeight
            headerViewHeight += -scrollView.contentOffset.y
            calendarInfoHeaderView.frame = CGRectMake(0, scrollView.contentOffset.y, self.tableView.bounds.width, headerViewHeight)
            
        }else{

            let alpha = min((1/(tableHeaderViewDefaultHeight - self.tableView.contentInset.top) * (contentOffsetY)), 1)
            self.navigationController?.navigationBar.subviews[0].alpha = alpha
            
        }
    }
```

