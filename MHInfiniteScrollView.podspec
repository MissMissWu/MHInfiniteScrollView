Pod::Spec.new do |s|

  s.name         = "MHInfiniteScrollView"
  s.version      = "1.0.0"
  s.summary      = "A good infinite scrollView made by CoderMikeHe"
  s.homepage     = "https://github.com/CoderMikeHe/MHInfiniteScrollView"
  s.license      = "MIT"
  s.authors      = {"CoderMikeHe" => "491273090@qq.com"}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/CoderMikeHe/MHInfiniteScrollView.git", :tag => s.version }
  s.source_files  = "MHInfiniteScrollView", "MHInfiniteScrollView/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true

end