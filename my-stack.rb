template do
  AWSTemplateFormatVersion "2010-09-09"

  Description (<<-EOS).undent
    Kumogata Sample Template
    You can use Here document!
  EOS

  Parameters do
    InstanceType do
      Default "t2.micro"
      Description "Instance Type"
      Type "String"
    end
  end

  Mappings do
    AWSInstanceType2Arch(
      {"t2.micro"=>{"Arch"=>"HVM64"}}
    )
    AWSRegionArch2AMI(
      {"ap-northeast-1"=>{"HVM64"=>"ami-374db956"}}
    )
  end

  Resources do
    myEC2Instance do
      Type "AWS::EC2::Instance"
      Properties do
        ImageId do
          Fn__FindInMap "AWSRegionArch2AMI", _{ Ref "AWS::Region" }, _{
            Fn__FindInMap "AWSInstanceType2Arch", _{ Ref "InstanceType" }, "Arch"
          }
        end
        InstanceType { Ref "InstanceType" }
        KeyName "t-mochizuki"

        UserData do
          Fn__Base64 (<<-EOS).undent
            #!/bin/bash
            yum install -y httpd
            service httpd start
          EOS
        end
      end
    end
  end
end
