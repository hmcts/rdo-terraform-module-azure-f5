[f5]
${private_ip1} 

[f52]
${private_ip2} 

[f5:vars]
ansible_connection=ssh
ansible_user=${admin_username}
ansible_ssh_pass=${admin_password}

[f52:vars]
ansible_connection=ssh
ansible_user=${admin_username}
ansible_ssh_pass=${admin_password}