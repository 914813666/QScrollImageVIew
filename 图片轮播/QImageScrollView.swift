//
//  QImageScrollView.swift
//  图片轮播
//
//  Created by qzp on 15/12/11.
//  Copyright © 2015年 qzp. All rights reserved.
//

import UIKit
///图片轮播
class QImageScrollView: UIView {
 
    
    typealias ClickImageViewAtIndex = ((index: Int) -> Void)?
    
    //回调
    var clickImageViewClosure: ClickImageViewAtIndex
    //切换图片的时间,默认3s
    var duration: NSTimeInterval = 2
    //切换图片是，运动的时间默认0.7s
    var speedDuration: NSTimeInterval = 0.7
    
    
  
    
    ///是否自动滚动
    private var autoScroll: Bool = true
    private var images: [UIImage]! = []
    private var isRight: Bool = true
    private var currentIndex: Int = 0
    private var imageViewContentModel: UIViewContentMode = UIViewContentMode.ScaleAspectFill
    private var imageViews: [UIImageView]! = []
    private var timer: NSTimer?
    private var isDrug: Bool = false
 
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    
    
    init(frame: CGRect, images: [UIImage]) {
        super.init(frame: frame)
        self.images = images
        self.clipsToBounds = true
 
        
        initializeScrollView()
        addImageViews()
        addPageControl()
        
        if self.autoScroll == true {
            addTimerLoop()
        }
        
       
        
    }
    deinit {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func qImageScrollWithFrame(frame: CGRect,images: [UIImage])-> QImageScrollView {
        
        return QImageScrollView(frame: frame, images: images)
    }
    
    
    ///初始化滚动视图
    func initializeScrollView() {
        scrollView = {
            let scrollView = UIScrollView(frame: self.bounds)
            scrollView.pagingEnabled = true
            scrollView.delegate = self
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height)
            scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0) //当前显示中间那张
            self.addSubview(scrollView)
            return scrollView
            }()
        
    }
    
    ///添加imageView
    func addImageViews() {
        
        self.scrollView.contentSize = CGSizeMake(3 * self.bounds.size.width, 0)
        for i in 0..<3 { //创建3个imageview
            let currentFrame: CGRect = CGRectMake(self.bounds.size.width * CGFloat(i), 0, self.bounds.size.width, self.bounds.size.height)
            
            let imageView = UIImageView(frame: currentFrame)
            imageView.contentMode = self.imageViewContentModel
            imageView.clipsToBounds = true
            self.scrollView.addSubview(imageView)
            self.imageViews.append(imageView)
            
            let btn = UIButton(frame: currentFrame)
            btn.addTarget(self, action: "buttonClick:", forControlEvents: .TouchUpInside)
            self.scrollView.addSubview(btn)
        
            
        
         }
        
        //设置初始化显示的imageview
        self.imageViews[0].image = self.images[realIndex(-1)]
        self.imageViews[1].image = self.images[realIndex(0)]
        self.imageViews[2].image = self.images[realIndex(1)]
    
    
    }
    
    ///添加timer
    func addTimerLoop() {
        self.translatesAutoresizingMaskIntoConstraints = false
        if self.images.count <= 1 { //1张图片不执行轮播
            self.timer?.invalidate()
            self.timer = nil
            return
        }
        
        if self.timer == nil {
            self.timer = NSTimer(timeInterval: duration, target: self, selector: "changeOffset", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        }
        
      
    
    }
    ///添加PageControl
    func addPageControl() {
        
        pageControl = {
            let pc = UIPageControl(frame: CGRectMake(0,self.bounds.size.height - 20,self.bounds.size.width,20))
            pc.numberOfPages = self.images.count
            pc.currentPage = self.currentIndex
            self.addSubview(pc)
            return pc
            }()
        
    
    }
    
  
    
    ///获取真实下标
    func realIndex(index: Int) -> Int {
        var tempIndex = index
        if index > self.images.count - 1  {
            tempIndex = 0
        } else if index < 0 {
            tempIndex = self.images.count - 1
        }
        
        return tempIndex
    }
   
    func changeOffset() {
        if self.isDrug == true {
            return
        }
        
        var offset = self.scrollView.contentOffset
        offset.x += offset.x
        self.scrollView.setContentOffset(offset, animated: true)

        if offset.x >= self.bounds.size.width * 2 || offset.x == 0{
            offset.x = self.bounds.size.width
        }
        
    }
    
    
    
    func buttonClick(btn: UIButton) {
        print(self.currentIndex)
        if self.clickImageViewClosure != nil {
            self.clickImageViewClosure!(index: self.currentIndex)
        }
    }
    
   

}


extension QImageScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
   
        
        let offsetX = scrollView.contentOffset.x
       
    
        if offsetX == 0 {
            
            self.currentIndex = realIndex(--self.currentIndex)
            self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0)
            self.imageViews[0].image = self.images[realIndex(self.currentIndex-1)]
            self.imageViews[1].image = self.images[realIndex(self.currentIndex)]
            self.imageViews[2].image = self.images[realIndex(self.currentIndex+1)]
            self.pageControl.currentPage = self.currentIndex
      
        } else if offsetX == self.bounds.size.width * 2{
        
            self.currentIndex = realIndex(++self.currentIndex)
            self.imageViews[0].image = self.images[realIndex(self.currentIndex-1)]
            self.imageViews[1].image = self.images[realIndex(self.currentIndex)]
            self.imageViews[2].image = self.images[realIndex(self.currentIndex+1)]
            self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0)
            self.pageControl.currentPage = self.currentIndex
        }
        
   
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.isDrug = true
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.isDrug = false
    }
    
}