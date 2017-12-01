template do
  AWSTemplateFormatVersion "2010-09-09"

  Description (<<-EOS).undent
    Kumogata Sample Template
    You can use Here document!
  EOS

  Parameters do
  end

  Mappings do
  end

  Resources do
    S3Bucket do
      Type "AWS::S3::Bucket"
      Properties do
        AccessControl "Private"
        BucketName "t-mochizuki"
      end
    end
  end
end
