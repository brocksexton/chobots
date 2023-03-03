<?php
$MAX_PAGES = 10;
$PAGE_TITLE = "Chobots Virtual World";
$POSTS_PER_PAGE = 5;
$config = [
    'server' => [
        'blogUrl' => 'https://blog.chobots.wiki',
    ],
    'public' => [
        'websiteTitle' => 'Chobots Virtual World',
    ],
];

$posts = [];
$authors = [];
$cacheFile = 'posts.cache';

if (file_exists($cacheFile) && filemtime($cacheFile) > time() - 3600) {
    // If the cache file exists and is less than 1 hour old, use it
    $posts = unserialize(file_get_contents($cacheFile));
} else {
    // Otherwise, make API requests to retrieve the posts
    for ($i = 0; $i < $MAX_PAGES; $i++) {
        try {
            $data = file_get_contents("{$config['server']['blogUrl']}/wp-json/wp/v2/posts?_embed&per_page=100");

            $newPosts = json_decode($data, true);

            foreach ($newPosts as $newPost) {
                $postExists = false;

                foreach ($posts as $post) {
                    if ($post['id'] === $newPost['id']) {
                        $postExists = true;
                        break;
                    }
                }

                if (!$postExists) {
                    $posts[] = $newPost;
                }
            }
        } catch (Exception $e) {
            break;
        }
    }

    // Store the results in the cache file
    file_put_contents($cacheFile, serialize($posts));
}

$promises = [];

foreach ($posts as $post) {
    $authorId = $post['author'];

    if (!isset($authors[$authorId])) {
        $authors[$authorId] = [];

        $promises[] = file_get_contents("{$config['server']['blogUrl']}/wp-json/wp/v2/users/{$authorId}");
    }
}

foreach ($promises as $promise) {
    $author = json_decode($promise, true);
    $id = $author['id'];

    $authors[$id] = $author;
}

$currentPage = isset($_GET['page']) ? (int) $_GET['page'] : 1;
$totalPages = ceil(count($posts) / $POSTS_PER_PAGE);

$posts = array_slice($posts, ($currentPage - 1) * $POSTS_PER_PAGE, $POSTS_PER_PAGE);
?>

<!DOCTYPE html>
<html>
<head>
    <title><?= $PAGE_TITLE . ' | ' . $config['public']['websiteTitle'] ?></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="keywords" content="family virtual world, kids and parents, kids education, learn by playing, fun online games for children, fun games for children, online games for kids, games on line for kids, children online games, online games for children, online games for preschool, online games for preschoolers, online games for preschool children, educational online games for children, free online games for young children, online games for small children"/>
    <meta name="description" content="Chobots is an entertaining virtual world, a family game aimed at creating an interesting, safe and learning environment for your kids."/>
    <meta http-equiv="Pragma" content="no-cache"/>
    <meta http-equiv="Expires" content="-1"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../assets/imgB/favicon.ico" type="image/png">
    <link rel="stylesheet" href="../assets/stylesheets/style-chobotsblog.css" type="text/css" media="screen" title="no title" charset="utf-8"/>
    <style>
        #skyscraper-banner img {
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
        }
    </style>
    <style>
        .site-container {
            background-color: white;
            border-radius: 10px 10px 0 0;
            padding: 20px;
            width: 80%;
            margin: 40px auto;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }  

        .post-container {
            padding: 20px;
            width: 80%;
            margin: 40px auto;
        } 
        
        .post-title a {
            color: black;
            text-decoration: none;
        }
        
        .post-title {
            font-size: 24px;
            margin-bottom: 10px;
        }

        .post-author {
            font-size: 18px;
            margin-bottom: 20px;
        }

        .post-content {
            font-size: 16px;
            line-height: 1.5;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <div class="site-container">
            <div class="content">
                <div class="header">
                    <div class="menu">
                        <ul>
                            <li><a href="index.html">Home</a></li>
                            <li><a href="https://kavalok.net/management" target="_blank">Management</a></li>
                            <li><a href="/blog">Community</a></li>
                            <li><a href="https://discord.gg/ewnWbAbqtk" target="_blank">Discord</a></li>
                        </ul>
                    </div>
                    <center><img src="https://play.chobots.wiki/assets/images/logo.png" width="30%" height="30%"></center>
                </div>
            <?php
                $postsPerPage = 5;
                $totalPages = ceil(count($posts) / $postsPerPage);
                $currentPage = min(max(1, filter_input(INPUT_GET, 'page', FILTER_VALIDATE_INT)), $totalPages);
                $startIndex = ($currentPage - 1) * $postsPerPage;
                $endIndex = min($startIndex + $postsPerPage, count($posts));

                for ($i = $startIndex; $i < $endIndex; $i++) {
                    $post = $posts[$i];
            ?>
                <div class="post-container">
                    <div class="post">
                        <h2 class="post-title"><a href="#" style="color: black;"><?= $post['title']['rendered'] ?></a></h2>
                        <p class="post-author">By <?= $authors[$post['author']]['name'] ?></p>
                        <div class="post-content">
                            <?= $post['content']['rendered'] ?>
                        </div>
                    </div>
                </div>
            <?php
                }
            ?>
            <div class="pagination">
                <?php
                    if ($currentPage > 1) {
                        echo '<a href="?page=' . ($currentPage - 1) . '">Previous</a> ';
                    }

                    for ($i = 1; $i <= $totalPages; $i++) {
                        if ($i === $currentPage) {
                            echo $i . ' ';
                        } else {
                            echo '<a href="?page=' . $i . '">' . $i . '</a> ';
                        }
                    }

                    if ($currentPage < $totalPages) {
                        echo '<a href="?page=' . ($currentPage + 1) . '">Next</a>';
                    }
                ?>
            </div>
        </div>
    </div>
</body>
</html>