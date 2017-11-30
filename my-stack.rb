template do
  AWSTemplateFormatVersion "2010-09-09"

  Description (<<-EOS).undent
    Kumogata Sample Template
    You can use Here document!
  EOS

  Parameters do
    InstanceType do
      Default "t2.nano"
      Description "Instance Type"
      Type "String"
    end

    SSHLocation do
      Description "The IP address range that can be used to SSH to the EC2 instances"
      Type "String"
      MinLength 9
      MaxLength 18
      Default "0.0.0.0/0"
      AllowedPattern "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
      ConstraintDescription "must be a valid IP CIDR range of the form x.x.x.x/x."
    end
  end

  Mappings do
    AWSInstanceType2Arch(
      {"t2.nano"=>{"Arch"=>"HVM64"},
       "t2.micro"=>{"Arch"=>"HVM64"}}
    )
    AWSRegionArch2AMI(
      {"ap-northeast-1"=>{"HVM64"=>"ami-374db956"}}
    )
  end

  Resources do
    WebServerSecurityGroup do
      Type "AWS::EC2::SecurityGroup"
      Properties do
        GroupDescription "Enable SSH access"
        SecurityGroupIngress [
          _{
            IpProtocol "tcp"
            FromPort 22
            ToPort 22
            CidrIp do
              Ref "SSHLocation"
            end
          }
        ]
      end
    end

    WebServer do
      Type "AWS::EC2::Instance"
      Properties do
        ImageId do
          Fn__FindInMap "AWSRegionArch2AMI", _{ Ref "AWS::Region" }, _{
            Fn__FindInMap "AWSInstanceType2Arch", _{ Ref "InstanceType" }, "Arch"
          }
        end
        InstanceType { Ref "InstanceType" }
        SecurityGroups [
          _{ Ref "WebServerSecurityGroup" }
        ]
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
