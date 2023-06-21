Pod::Spec.new do |spec|
  spec.name         = "CloudHuiYanSDK_FW"
  spec.version      = "1.0.9"
  spec.summary      = "A short description of CloudHuiYanSDK_FW."
  spec.description  = "tencent huiyan SDK"
                   
  spec.homepage     = "http://EXAMPLE/CloudHuiYanSDK_FW"

  spec.license      = "MIT"

  spec.author       = { "clvchen" => "clvchen@tencent.com" }
  
  spec.framework    = ["Accelerate"]
  
  spec.compiler_flags = "-ObjC"

  spec.source       = { :path => '.' }

  spec.ios.deployment_target = '9.0'
  spec.ios.vendored_frameworks = 'framework/*.framework'
  spec.ios.vendored_libraries = 'framework/*.a'
  spec.ios.resource = 'resource/*.{bundle}'

end
