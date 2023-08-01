component=payment
source common.sh

rabbitmq_app_passwd=$1

if [ -z "${rabbitmq_app_passwd}" ]; then

  echo input rabbitmq password missing
  exit 1
fi


func_python_payment