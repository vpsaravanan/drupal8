<?php

namespace Drupal\test\Plugin\Block;

use Drupal\Core\Block\BlockBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Cache\Cache;

/**
 * Provides a 'Test' block.
 *
 * @Block(
 *   id = "user_post",
 *   admin_label = @Translation("Test Block"),
 *   category = @Translation("Custom")
 * )
 */

class UserPost extends BlockBase {
    public function build() {
        $content = 'This is test block by custom plugin';
        return [
        '#markup' => $content,
        '#cache' => [
        'max-age' => 60, // Cache for 60 seconds
        'contexts' => ['user'], // Vary by user
      ],
    ];
    }
}