class S3Client
  
  def initialize(bucket: ENV["AWS_S3_BUCKET_ID"])
    @client ||= Aws::S3::Client.new(region: 'ap-northeast-1')
    @bucket ||= bucket
  end
  
  def put_image(file:, key:)
    @client.put_object(bucket: @bucket, key: key, body: file)
  end
  
  def get_image(key:)
    presigner = Aws::S3::Presigner.new(client: @client)
    presigner.presigned_url(:get_object, bucket: @bucket, key: key, expires_in: 60)
  end
  
end