
#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
export PATH=/usr/local/bin:$PATH
yum -y install jq
easy_install pip
pip install awscli
aws configure set default.region ${region}
cat <<EOF > /etc/init/spot-instance-termination-notice-handler.conf
description "Start spot instance termination handler monitoring script"
author "Amazon Web Services"
start on started ecs
script
echo $$ > /var/run/spot-instance-termination-notice-handler.pid
exec /usr/local/bin/spot-instance-termination-notice-handler.sh
end script
pre-start script
logger "[spot-instance-termination-notice-handler.sh]: spot instance termination
notice handler started"
end script
EOF
cat <<EOF > /usr/local/bin/spot-instance-termination-notice-handler.sh
#!/bin/bash
while sleep 5; do
if [ -z $(curl -Isf http://169.254.169.254/latest/meta-data/spot/termination-time)]; then
/bin/false
else
logger "[spot-instance-termination-notice-handler.sh]: spot instance termination notice detected"
STATUS=DRAINING
ECS_CLUSTER=$(curl -s http://localhost:51678/v1/metadata | jq .Cluster | tr -d ")
CONTAINER_INSTANCE=$(curl -s http://localhost:51678/v1/metadata | jq .ContainerInstanceArn | tr -d ")
logger "[spot-instance-termination-notice-handler.sh]: putting instance in state $STATUS"

/usr/local/bin/aws  ecs update-container-instances-state --cluster $ECS_CLUSTER --container-instances $CONTAINER_INSTANCE --status $STATUS

logger "[spot-instance-termination-notice-handler.sh]: putting myself to sleep..."
sleep 120 # exit loop as instance expires in 120 secs after terminating notification
fi
done
EOF
chmod +x /usr/local/bin/spot-instance-termination-notice-handler.sh