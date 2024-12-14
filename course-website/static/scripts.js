function toggleVideos(category) {
  // Get the video list elements
  const ansibleVideos = document.getElementById('ansible-videos');
  const terraformVideos = document.getElementById('terraform-videos');
  const blogs = document.getElementById('blogs'); // Added for blogs

  if (category === 'ansible-videos') {
    // Toggle Ansible videos and hide others
    terraformVideos.style.display = 'none';
    if (blogs) blogs.style.display = 'none'; // Hide Blogs if present
    ansibleVideos.style.display = ansibleVideos.style.display === 'block' ? 'none' : 'block';
  } else if (category === 'terraform-videos') {
    // Toggle Terraform videos and hide others
    ansibleVideos.style.display = 'none';
    if (blogs) blogs.style.display = 'none'; // Hide Blogs if present
    terraformVideos.style.display = terraformVideos.style.display === 'block' ? 'none' : 'block';
  } else if (category === 'blogs') {
    // Toggle Blogs and hide others
    ansibleVideos.style.display = 'none';
    terraformVideos.style.display = 'none';
    blogs.style.display = blogs.style.display === 'block' ? 'none' : 'block';
  }
}
