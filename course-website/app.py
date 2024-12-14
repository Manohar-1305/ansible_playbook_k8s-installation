from flask import Flask, render_template, request, redirect, url_for, session, flash
import os

app = Flask(__name__)
app.secret_key = os.urandom(24)

# In-memory user storage (for demonstration only)
users = {"admin": "password123"}

@app.route('/')
def home():
    if 'username' in session:
        return render_template('home.html', username=session['username'])
    return redirect(url_for('login'))


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username in users and users[username] == password:
            session['username'] = username
            return redirect(url_for('home'))
        else:
            flash('Invalid username or password', 'danger')
    return render_template('login.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username in users:
            flash('Username already exists. Choose a different username.', 'danger')
        else:
            users[username] = password
            flash('Registration successful! You can now log in.', 'success')
            return redirect(url_for('login'))
    return render_template('register.html')

@app.route('/vpc-creation')
def vpc_creation():
    return render_template('vpc-creation.html')

@app.route('/1.vpc-provider.html')
def vpc_provider():
    return render_template('vpc-provider.html')

@app.route('/public_subnet')
def public_subnet():
    return render_template('public_subnet.html')


@app.route('/public_route')
def public_route():
    return render_template('public_route.html')

@app.route('/private_subnet')
def private_subnet():
    return render_template('private_subnet.html')

@app.route('/private_route')
def private_route():
    return render_template('private_route.html')

@app.route('/IAMCReation')
def IAMCReation():
    return render_template('IAMCReation.html')

@app.route('/natgateway')
def natgateway():
    return render_template('natgateway.html')

@app.route('/securitygroup')
def securitygroup():
    return render_template('security-group_1.html')


@app.route('/instancecreation')
def instancecreation():
    return render_template('instance_creation.html')

@app.route('/instance_nfs_creation')
def instance_nfs_creation():
    return render_template('instance_nfs_creation.html')

@app.route('/instance_master_worker_creation')
def instance_master_worker_creation():
    return render_template('instance_master_worker_creation.html')

@app.route('/terraform_output')
def terraform_output():
    return render_template('terraform_output.html')  # Replace with the correct template

@app.route('/terraform_enviroment_creation')
def terraform_enviroment_creation():
    # Render a template or perform logic for this endpoint
    return render_template('terraform_enviroment_creation.html')  # Ensure this template exists

@app.route('/terraform_user_data_bastion')
def terraform_user_data_bastion():
    return render_template('terraform_user_data_bastion.html')

@app.route('/terraform_user_data_nfs')
def terraform_user_data_nfs():
    # Replace with appropriate logic
    return render_template('terraform_user_data_nfs.html')

@app.route('/terraform_user_data_loadbalancer')
def terraform_user_data_loadbalancer():
    # Replace with appropriate logic
    return render_template('terraform_user_data_loadbalancer.html')


@app.route('/terraform_user_data_master')
def terraform_user_data_master():
    # Replace with appropriate logic
    return render_template('terraform_user_data_master.html')

@app.route('/terraform_null_provisioner')
def terraform_null_provisioner():
    # Replace with appropriate logic
    return render_template('terraform_null_provisioner.html')

@app.route('/terraform_variables')
def terraform_variables():
    # Replace with appropriate logic
    return render_template('terraform_variables.html')
@app.route('/terraform_infra_creation')
def terraform_infra_creation():
    # Replace with appropriate logic
    return render_template('terraform_infra_creation.html')
@app.route('/creating_inventory_creation')
def creating_inventory():
    # Replace with appropriate logic
    return render_template('creating_inventory.html')
@app.route('/changes_in_inventory')
def changes_in_inventory():
    # Replace with appropriate logic
    return render_template('changes_in_inventory.html')
@app.route('/git_code')
def git_code():
    # Replace with appropriate logic
    return render_template('git_code.html')

@app.route('/ansible_inventory_code')
def ansible_inventory_code():
    # Replace with appropriate logic
    return render_template('ansible_inventory_code.html')

@app.route('/ansible_k8s_setup')
def ansible_k8s_setup():
    # Replace with appropriate logic
    return render_template('ansible_k8s_setup.html')

@app.route('/ansible_kubernetes_role')
def ansible_kubernetes_role():
    # Replace with appropriate logic
    return render_template('ansible_kubernetes_role.html')

@app.route('/terraform_overall_summary')
def terraform_overall_summary():
    # Replace with appropriate logic
    return render_template('terraform_user_data_master.html')

@app.route('/elasticip_lb')
def elasticip_lb():
    # Replace with appropriate logic
    return render_template('elasticip.html')
#################################################################
@app.route('/helm_role')
def helm_role():
    # Replace with appropriate logic
    return render_template('helm_role.html')

@app.route('/first_master_role')
def first_master_role():
    # Replace with appropriate logic
    return render_template('first_master_role.html')

@app.route('/add_master_role')
def add_master_role():
    # Replace with appropriate logic
    return render_template('add_master_role.html')

@app.route('/add_workers_role')
def add_workers_role():
    # Replace with appropriate logic
    return render_template('add_workers_role.html')

@app.route('/time_sync_role')
def time_sync_role():
    # Replace with appropriate logic
    return render_template('time_sync_role.html')

@app.route('/kubectl_role')
def kubectl_role():
    # Replace with appropriate logic
    return render_template('kubectl_role.html')

@app.route('/adding_tags')
def adding_tags():
    # Replace with appropriate logic
    return render_template('adding_tags.html')
@app.route('/cni_role')
def cni_role():
    # Replace with appropriate logic
    return render_template('cni_role.html')

@app.route('/add_masters_label')
def add_masters_label():
    # Replace with appropriate logic
    return render_template('add_masters_label.html')
@app.route('/add_workers_label')
def add_workers_label():
    # Replace with appropriate logic
    return render_template('add_workers_label.html')
@app.route('/nfs_setup')
def nfs_setup():
    # Replace with appropriate logic
    return render_template('nfs_setup.html')

@app.route('/nfs_client_setup')
def nfs_client_setup():
    # Replace with appropriate logic
    return render_template('nfs_client_setup.html')

@app.route('/K8s_installer')
def K8s_installer():
    # Replace with appropriate logic
    return render_template('K8s_installer.html')

@app.route('/cluster_setup')
def cluster_setup():
    # Replace with appropriate logic
    return render_template('cluster_setup.html')
#######################################
@app.route('/provider_blog')
def provider_blog():
    # Replace with appropriate logic
    return render_template('vpc_provider_blog.html')

@app.route('/vpc_creation_blog')
def vpc_creation_blog():
    # Replace with appropriate logic
    return render_template('vpc_creation_blog.html')

@app.route('/terraform_public_subnet_blog')
def terraform_public_subnet_blog():
    # Replace with appropriate logic
    return render_template('terraform_public_subnet_blog.html')

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('login'))
if __name__ == '__main__':
    app.run(debug=True)
