resource "aws_instance" "app_server" {
  count           = var.instance_count
  ami             = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type   = var.instance_type
  key_name        = var.ec2_key_pair
  security_groups = [aws_security_group.ec2.name]
  subnet_id       = aws_subnet.subnet1.id

  tags = {
    Name = "AppServer-${count.index}"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3
              pip3 install pymysql

              # Set environment variables
              echo "export RDS_HOST='${aws_db_instance.main.endpoint}'" >> /home/ec2-user/.bash_profile
              echo "export RDS_USER='${var.db_username}'" >> /home/ec2-user/.bash_profile
              echo "export RDS_PASSWORD='${var.db_password}'" >> /home/ec2-user/.bash_profile
              echo "export RDS_DB='recognitiondb'" >> /home/ec2-user/.bash_profile
              source /home/ec2-user/.bash_profile

              # Create Python script
              cat <<EOT >> /home/ec2-user/fetch_data.py
              import pymysql
              import os

              # Database settings from environment variables
              rds_host = os.environ.get('RDS_HOST')
              rds_user = os.environ.get('RDS_USER')
              rds_password = os.environ.get('RDS_PASSWORD')
              rds_db = os.environ.get('RDS_DB')

              # Connect to the database
              connection = pymysql.connect(host=rds_host, user=rds_user, password=rds_password, db=rds_db)

              def fetch_data():
                  try:
                      with connection.cursor() as cursor:
                          sql = "SELECT * FROM CallOut"  # Example query
                          cursor.execute(sql)
                          result = cursor.fetchall()
                          for row in result:
                              print(row)
                  
                  except Exception as e:
                      print(f"Error: {str(e)}")
                  
                  finally:
                      connection.close()

              if __name__ == "__main__":
                  fetch_data()
              EOT

              # Make the Python script executable and run it
              chmod +x /home/ec2-user/fetch_data.py
              /usr/bin/python3 /home/ec2-user/fetch_data.py
              EOF
}
